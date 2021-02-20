import 'dart:math';

import 'package:base_plugin/manager/statistics_manager.dart';
import 'package:sprintf/sprintf.dart';

class StatisticsModel {
  ///必须继承字段
  String action = "";

  String createdTime;

  String eventID;

  String packageName;

  String packageVersion;

  String code;

  String identify;

  Map<String, String> data = Map();

  StatisticModel(String code) {
    this.code = code ?? "";
    this.identify = StatisticsManager.getInstance().eventIdentify??"";
    DateTime dateTime = DateTime.now().toUtc();
    eventID = generateEventID();
    packageName = StatisticsManager.getInstance().packageName??"";
    packageVersion = StatisticsManager.getInstance().packageVersion??"";
    this.createdTime = sprintf("%i-%02i-%02i'T'%02i:%02i:%02i.%i'Z'", [
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond
    ]);
  }

  String generateEventID({int length = 18}) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM123456789';
    String left = '';
    for (var i = 0; i < length; i++)
      left = left + alphabet[Random().nextInt(alphabet.length)];
    return left;
  }

  String getParam() {
    StringBuffer stringBuilder = StringBuffer();
    stringBuilder.write("{");

    data.forEach((key, value) => stringBuilder
      ..write("\"")
      ..write(key)
      ..write("\":\"")
      ..write(value)
      ..write("\","));

    if (data.length > 1)
      stringBuilder.write(stringBuilder.toString().replaceRange(stringBuilder.length - 1, stringBuilder.length, "}"));
    else
      stringBuilder.write("}");
    return stringBuilder.toString();
  }

  Map<String, dynamic> toJson(){
    return {
      "code": code,
      "action": action??"",
      "createdTime":createdTime,
      "eventID":eventID,
      "packageName":packageName??"",
      "packageVersion":packageVersion??"",
      "identify":identify??"",
      "data": data
    };
  }

}