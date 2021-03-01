import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

///路由管理
class RouteManager{

  /// 单例
  static RouteManager _instance;

  static RouteManager get instance => _getInstance();

  RouteManager._internal(){
    router = FluroRouter.appRouter;
  }

  static RouteManager _getInstance(){
    if(_instance == null)
      _instance = RouteManager._internal();
    return _instance;
  }

  //页面路由
  FluroRouter router;

  ///路由传参存储
  Map<String, dynamic> paramsMap = Map();

  ///路由栈管理
  List<String> routerStack = List();

  Future<dynamic> navigateTo(BuildContext context, String path, {bool replace = false, bool clearStack = false,dynamic bundle, TransitionType transition = TransitionType.cupertino}) {
    if(context != null)
      FocusScope.of(context).requestFocus(FocusNode());
    paramsMap[path] = bundle;
    printRouteStack();
    return router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition);
  }

  Future<dynamic> navigateToWithResult(BuildContext context, String path, {bool replace = false, bool clearStack = false,dynamic bundle, TransitionType transition = TransitionType.cupertino,Function resCallBack}) {
    FocusScope.of(context).requestFocus(FocusNode());
    paramsMap[path] = bundle;
    printRouteStack();
    return router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transition)
        .then((result) {
      // 页面返回result为null
      if (result == null)
        return;
      if(resCallBack != null)
        resCallBack(result);
    }).catchError((error) {
      print("$error");
    });
  }

  bool navigateBack(BuildContext context){
    if(context != null)
      FocusScope.of(context).requestFocus(FocusNode());
    bool canPop = Navigator.canPop(context);
    if (canPop)
      Navigator.of(context).pop();
    printRouteStack();
    return canPop;
  }

  void navigateBackWithResult<T>(BuildContext context,T result){
    if(context != null)
      FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop<T>(context, result);
    printRouteStack();
  }

  /// 回退到指定页面
  bool navigateBackUntil(BuildContext context,String routeName) {
    FocusScope.of(context).requestFocus(FocusNode());
    bool canPop = Navigator.canPop(context);
    if (canPop)
      Navigator.of(context).popUntil(ModalRoute.withName(routeName));
    printRouteStack();
    return canPop;
  }

  void printRouteStack({String description = "Current Page Stacks:"}){
    StringBuffer buffer = StringBuffer("$description[");
    routerStack.forEach((element)=> buffer.write("$element,"));
    buffer.write("]");
    print(buffer);
  }
}