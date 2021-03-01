import 'dart:async';
import 'dart:convert';

import 'package:base_plugin/export_config.dart';
import 'package:base_plugin/manager/timer_manager.dart';
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

  ///数组发送状态下存储的List
  List<dynamic> _storeList;

  ///目前发送器状态
  bool _isActive = false;

  ///数组发送状态下发送延迟
  int _sendDuration;

  ///是否复用http实例
  bool _isReuse = true;

  ///新的Http实例
  HttpManager _newHttpManager;

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
  ///@apiUrl 子地址
  ///@identify 标记
  ///@isNewAddress 是否复用当前的全局http请求
  ///@newHttpManagerCallBack 当isNewAddress为false生效，回调将返回新的HttpManager实例进行设置
  ///@sendDuration 多项发送间隔
  Future<bool> init(String apiUrl,String identify, {bool isReuse = true,
    Function newHttpManagerCallBack, int sendDuration = 5000}) async{
    assert((!isReuse && newHttpManagerCallBack != null)||(isReuse && newHttpManagerCallBack == null));
    _balance = await LoadBalancer.create(3, IsolateRunner.spawn);

    if(!_isReuse){
      _newHttpManager = HttpManager.newInstance("statistic_instance");
      newHttpManagerCallBack(_newHttpManager);
    }

    _isReuse = isReuse;
    _isActive = true;
    _eventIdentify = identify;

    _packageName = ExportConfig.instance.packageName??"";
    _packageVersion = ExportConfig.instance.version??"";

    _apiUrl = apiUrl;
    _sendDuration = sendDuration;

    _storeList = List<dynamic>();

    _start();
    return true;
  }

  void _start(){
    TimerManager.getInstance().startTimer((timer,tick){
      _sendArrayEvent();
    }, duration: Duration(seconds: _sendDuration), key: STATISTIC_TIMER);
  }

  void _sendArrayEvent(){
    _balance.run<void,List<dynamic>>(sendArrayEvent, _storeList);
  }

  ///发送事件
  void sendEvent(dynamic event, {StatisticSendType sendType = StatisticSendType.SINGLE}){
    if(_isActive){
      if(sendType == StatisticSendType.ARRAY)
        _storeList.add(event);
      else
        _balance.run<void,dynamic>(sendSingleEvent, event);
    }
  }

  void sendSingleEvent(dynamic argument){
    if(!_isReuse)
      _newHttpManager.postRequest(_apiUrl, data: argument);
    else
      HttpManager.instance.postRequest(_apiUrl, data: argument);
  }

  void sendArrayEvent(List<dynamic> argument){
    if(!_isReuse)
      _newHttpManager.postRequest(_apiUrl, data: jsonEncode(argument));
    else
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