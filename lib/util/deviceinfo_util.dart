import 'dart:async';
import 'dart:io';

import 'package:base_plugin/export_config.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class DeviceInfoUtil {

  Future<void> readDeviceInfo() async {
    final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ExportConfig.instance.applicationName = packageInfo.appName;
    ExportConfig.instance.packageName = packageInfo.packageName;
    ExportConfig.instance.buildNumber = packageInfo.buildNumber;
    ExportConfig.instance.version = packageInfo.version;
    try {
      if (Platform.isAndroid)
        ExportConfig.instance.deviceInfoMap = _readAndroidBuildData(await _deviceInfoPlugin.androidInfo);
      else if (Platform.isIOS)
        ExportConfig.instance.deviceInfoMap = _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo);
    } catch(e) {
      ExportConfig.instance.deviceInfoMap = null;
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return {
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return {
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
