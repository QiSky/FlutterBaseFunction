import 'dart:async';
import 'dart:convert';

import 'package:base_plugin/export_config.dart';
import 'package:base_plugin/manager/timer_manager.dart';
import 'package:base_plugin/model/statistics/statistics_model.dart';
import 'package:isolate/isolate_runner.dart';
import 'package:isolate/load_balancer.dart';

import 'http_manager.dart';

enum StatisticSendType{
  SINGLE,
  ARRAY
}

class StatisticsManager{

  /// 单例
  static StatisticsManager _instance;

  ///多线程isolate池
  LoadBalancer _balance;

  ///发送地址的子Url
  String _apiUrl;

  ///包名
  String _packageName;

  ///版本号
  String _packageVersion;

  ///事件唯一识别码（根据此属性进行可视化识别）
  String _eventIdentify;

  ///发送方式
  StatisticSendType _sendType;

  ///数组发送状态下存储的List
  List<StatisticsModel> _storeList;

  ///目前发送器状态
  bool _isActive = false;

  ///数组发送状态下发送延迟
  int _sendDuration;

  String get packageName => _packageName;

  String get packageVersion => _packageVersion;

  String get eventIdentify => _eventIdentify;

  static const STATISTIC_TIMER = "Statistic_Timer";

  static StatisticsManager getInstance(){
    if(_instance == null)
      _instance = StatisticsManager();
    return _instance;
  }

  ///初始化
  Future<bool> init(String apiUrl,String identify, {StatisticSendType sendType = StatisticSendType.SINGLE,
    int sendDuration = 5000}) async{
    _balance = await LoadBalancer.create(3, IsolateRunner.spawn);

    _isActive = true;
    _eventIdentify = identify;

    _packageName = ExportConfig.instance.packageName??"";
    _packageVersion = ExportConfig.instance.version??"";

    _sendType = sendType;
    _apiUrl = apiUrl;
    _sendDuration = sendDuration;

    if(sendType == StatisticSendType.ARRAY){
      assert(sendDuration > 0);
      _storeList = List();
    }

    _start();
    return true;
  }


  void _start(){
    TimerManager.getInstance().startTimer((timer,tick){
      _sendArrayEvent();
    }, duration: Duration(seconds: _sendDuration), key: STATISTIC_TIMER);
  }

  void _sendArrayEvent(){
    _balance.run<void,List<StatisticsModel>>(sendArrayEvent, _storeList);
  }

  ///发送事件
  void sendEvent(StatisticsModel event){
    if(_isActive){
      if(_sendType == StatisticSendType.ARRAY)
        _storeList.add(event);
      else
        _balance.run<void,StatisticsModel>(sendSingleEvent, event);
    }
  }

  void sendSingleEvent(StatisticsModel argument){
    HttpManager.instance.postRequest(_apiUrl, data: argument);
  }

  void sendArrayEvent(List<StatisticsModel> argument){
    HttpManager.instance.postRequest(_apiUrl, data: jsonEncode(argument));
    argument.clear();
  }

  ///暂停发送
  void pause(){
    assert(_isActive);
    _isActive = false;
    TimerManager.getInstance().clearTimer(STATISTIC_TIMER);
  }

  ///重启发送
  void restart(){
    _isActive = true;
    _start();
  }
}