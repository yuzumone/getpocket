import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getpocket/data/local/app_shared_preferences.dart';

final prefeneceRepositoryProvider = Provider((ref) => PreferenceRepository(
    appSharedPreferences: ref.read(appSharedPrefenrecesProvider)));

class PreferenceRepository {
  final AppSharedPreferences appSharedPreferences;
  final String tokenKey = 'token';

  PreferenceRepository({required this.appSharedPreferences});

  Future<void> setToken(String token) async {
    final prefs = await appSharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await appSharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    if (token == null) {
      return null;
    } else {
      return token;
    }
  }
}
