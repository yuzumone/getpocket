import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appSharedPrefenrecesProvider = Provider((ref) => AppSharedPreferences());

class AppSharedPreferences {
  late SharedPreferences _prefs;

  Future<SharedPreferences> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
}
