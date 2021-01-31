import 'package:base_plugin/export_config.dart';
import 'package:connectivity/connectivity.dart';

class NetworkListener {
  NetworkListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)
        ExportConfig.instance.isNetworkConnected = true;
      else
        ExportConfig.instance.isNetworkConnected = false;
    });
  }
}
