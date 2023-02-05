import 'package:flutter/material.dart';
import 'package:getpocket/data/repository/pocket_repository.dart';
import 'package:getpocket/data/repository/preference_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              final preferenceRepository =
                  ref.read(prefeneceRepositoryProvider);
              final pocketRepository = ref.read(pocketRepositoryProvider);
              final token = await pocketRepository.getAccessToken();
              await preferenceRepository.setToken(token);
            },
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}
