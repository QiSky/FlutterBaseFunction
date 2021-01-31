
class ExportConfig{

  bool isNetworkConnected = true;

  String applicationName;

  String packageName;

  String version;

  String buildNumber;

  Map<String,dynamic> deviceInfoMap;

  /// 单例
  static ExportConfig _instance;

  static ExportConfig get instance => _getInstance();

  ExportConfig._internal();

  static ExportConfig _getInstance(){
    if(_instance == null)
      _instance = ExportConfig._internal();
    return _instance;
  }

}