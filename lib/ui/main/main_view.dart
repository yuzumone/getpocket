import 'package:flutter/material.dart';
import 'package:getpocket/data/model/item.dart';
import 'package:getpocket/data/repository/pocket_repository.dart';
import 'package:getpocket/data/repository/preference_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final pocketItemProvider = FutureProvider.autoDispose<List<Item>>((ref) async {
  final prefenreceRepository = ref.watch(prefeneceRepositoryProvider);
  final pocketRepository = ref.watch(pocketRepositoryProvider);
  final token = await prefenreceRepository.getToken();
  if (token == null) {
    return <Item>[];
  } else {
    final items = await pocketRepository.getPocketItems(token);
    return items;
  }
});

class MainView extends HookConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(pocketItemProvider).when(
          data: (items) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(pocketItemProvider.future),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemView(item: items[index]);
                },
              ),
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

class ItemView extends HookConsumerWidget {
  final Item item;

  const ItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await launchUrlString(
          item.givenUrl,
          mode: LaunchMode.externalApplication,
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                item.topImageUrl != null
                    ? Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        child: Image.network(
                          item.topImageUrl!,
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.resolvedTitle?.isNotEmpty ?? false
                            ? item.resolvedTitle!
                            : item.givenUrl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Visibility(
                        visible: item.excerpt != null,
                        child: Text(
                          item.excerpt ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  final repo = ref.read(pocketRepositoryProvider);
                  final token =
                      await ref.read(prefeneceRepositoryProvider).getToken();
                  await repo.archivePocketItems([item], token!);
                },
                icon: const Icon(
                  Icons.archive,
                  size: 24.0,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
