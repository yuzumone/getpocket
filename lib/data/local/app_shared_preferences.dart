import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appSharedPrefenrecesProvider = Provider((ref) => AppSharedPreferences());

class AppSharedPreferences {
  late SharedPreferences _prefs;

  Future<SharedPreferences> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
}
