import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static SharedPreferences _prefs;

  static void saveData(String key, dynamic data) {
    assert(_prefs != null);
    if (data is String) _prefs.setString(key, data);
    if (data is int) _prefs.setInt(key, data);
    if (data is double) _prefs.setDouble(key, data);
    if (data is bool) _prefs.setBool(key, data);
    if (data is List<String>) _prefs.setStringList(key, data);
  }

  static dynamic getData(String key) {
    assert(_prefs != null);
    if (_prefs.containsKey(key))
      return _prefs.get(key);
    else
      return null;
  }

  static Future<void> init() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  static List<String> getDataList(String key) {
    assert(_prefs != null);
    if (_prefs.containsKey(key))
      return _prefs.getStringList(key);
    else
      return null;
  }

  static void deleteData(String key) {
    assert(_prefs != null);
    _prefs.remove(key);
  }

  static void deleteAllData() {
    assert(_prefs != null);
    _prefs.clear();
  }
}
