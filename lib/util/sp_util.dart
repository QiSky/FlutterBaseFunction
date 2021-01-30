
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil{

  static SharedPreferences _prefs;

  static void saveData(String key,dynamic data) async {
    await _init();
    if(data is String)
      _prefs.setString(key, data);
    if(data is int)
      _prefs.setInt(key, data);
    if(data is double)
      _prefs.setDouble(key, data);
    if(data is bool)
      _prefs.setBool(key, data);
    if(data is List<String>)
      _prefs.setStringList(key, data);
  }

  static Future<dynamic> getData(String key) async{
    await _init();
    if(_prefs.containsKey(key))
      return _prefs.get(key);
    else
      return null;
  }

  static Future<void> _init() async{
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<String>> getDataList(String key) async{
    await _init();
    if(_prefs.containsKey(key))
      return _prefs.getStringList(key);
    else
      return null;
  }

  static void deleteData(String key) async {
    await _init();
    _prefs.remove(key);
  }

  static void deleteAllData() async {
    await _init();
    _prefs.clear();
  }
}