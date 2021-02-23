
import 'dart:async';

class TimerManager{
  
  Map<String,dynamic> _timerMap = Map();
  
  /// 单例
  static TimerManager _instance;

  static TimerManager getInstance(){
    if(_instance == null)
      _instance = TimerManager();
    return _instance;
  }

  ///启动单次定时器
  void startTimerOnce(Function timerCallBack){
    Timer.run(() => timerCallBack?.call());
  }

  ///启动有间隔时间的多次定时器
  void startTimer(Function timerCallBack,{Duration duration,String widget,String key}){
    assert((widget!=null&&widget.isNotEmpty)||(key!=null&&key.isNotEmpty));
    if(widget!=null&&widget.isNotEmpty){
      List<Timer> list;
      if(_timerMap.containsKey(widget)!=null)
        list = _timerMap.containsKey(widget) as List<Timer>;
      else
        list = [];
      list.add(Timer.periodic(duration, (timer) {
        timerCallBack(timer,timer.tick);
      }));
      _timerMap[widget]=list;
    }else if(key!=null&&key.isNotEmpty){
      // assert(!_timerMap.containsKey(key));
      _timerMap[key] = Timer.periodic(duration, (timer) {
        timerCallBack(timer,timer.tick);
      });
    }
  }

  void clearTimer(String timerName){
    if(_timerMap.containsKey(timerName)){
      var res = _timerMap[timerName];
      if(res == null)
        return;
      if(res is List<Timer>)
        autoRelease(timerName);
      else{
        Timer timer = res as Timer;
        _timerMap?.remove(timerName);
        timer?.cancel();
      }
    }
  }

  void getAllTimerName() async{
    _timerMap.forEach((key, value) {
      print("Timer name:$key");
    });
  }

  bool hasTimer(String timerName){
    return _timerMap?.containsKey(timerName);
  }

  ///根据widget名称自动释放定时器
  void autoRelease(String widget) async{
    assert(_timerMap.containsKey(widget));
    _timerMap.containsKey(widget) as List<Timer>..forEach((element) {
      if(element != null && element.isActive)
        element.cancel();
    });
    _timerMap.remove(widget);
  }
}