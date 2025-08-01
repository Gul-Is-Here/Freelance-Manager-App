import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<LocalStorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double getDouble(String key, [double defaultValue = 0.0]) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String getString(String key, [String defaultValue = '']) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBool(String key, [bool defaultValue = false]) {
    return _prefs.getBool(key) ?? defaultValue;
  }
}