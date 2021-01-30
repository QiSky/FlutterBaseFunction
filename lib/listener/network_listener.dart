import 'package:base_plugin/export_config.dart';
import 'package:connectivity/connectivity.dart';

class NetworkListener {
  NetworkListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)
        ExportConfig.isNetworkConnected = true;
      else
        ExportConfig.isNetworkConnected = false;
    });
  }
}
