import 'dart:async';
import 'dart:io';

import 'package:base_plugin/export_config.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class DeviceInfoUtil {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> readDeviceInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    ExportConfig.applicationName = packageInfo.appName;
    ExportConfig.packageName = packageInfo.packageName;
    ExportConfig.buildNumber = packageInfo.buildNumber;
    ExportConfig.version = packageInfo.version;
    try {
      if (Platform.isAndroid)
        ExportConfig.deviceInfoMap = _readAndroidBuildData(await _deviceInfoPlugin.androidInfo);
      else if (Platform.isIOS)
        ExportConfig.deviceInfoMap = _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo);
    } on PlatformException {
      ExportConfig.deviceInfoMap = null;
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
