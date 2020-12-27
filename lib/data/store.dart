import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {

  static Future<void> saveString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static void saveMap(String key, Map<String, dynamic> value) {
    saveString(key, json.encode(value));
  }

  static Future<String> getString(String key)  async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static Future<Map<String, dynamic>>getMap(String key) async {
    try {
      final value = json.decode(await getString(key));
      return value;
    } catch (_) {
      return null;
    }
  }

  static bool has(key) {
    return getString(key) != null;
  }

  static Future<void> delete(key) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}