import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ScrollController scrollController;

  const MainView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(pocketItemProvider).when(
          data: (items) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(pocketItemProvider.future),
              child: ListView.builder(
                controller: scrollController,
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

  String getHost(String? url) {
    if (url == null) return "";
    final uri = Uri.parse(url);
    return uri.host;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await launchUrlString(
          item.givenUrl,
          mode: LaunchMode.externalApplication,
        );
        HapticFeedback.mediumImpact();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getHost(item.resolvedUrl),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
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
            ),
          )
        ],
      ),
    );
  }
}
