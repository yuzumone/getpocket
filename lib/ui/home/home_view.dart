import 'package:flutter/material.dart';
import 'package:getpocket/data/repository/preference_repository.dart';
import 'package:getpocket/ui/login/login_view.dart';
import 'package:getpocket/ui/main/main_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tokenProvider = FutureProvider<String?>((ref) async {
  final preferenceRepository = ref.watch(prefeneceRepositoryProvider);
  final token = await preferenceRepository.getToken();
  return token;
});

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tokenProvider).when(
          loading: () {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
          data: (token) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: const Text('getpocket'),
                ),
                body: token == null ? const LoginView() : const MainView());
          },
          error: (error, stackTrace) => Scaffold(
            appBar: AppBar(
              title: const Text('getpocket'),
            ),
            body: Text(error.toString()),
          ),
        );
  }
}
