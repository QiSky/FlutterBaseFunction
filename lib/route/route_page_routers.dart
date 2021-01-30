import 'package:flutter/cupertino.dart';

abstract class RoutePageRouters {

  void insertRoutes({List<RoutePageRouter> list,Function insertCallBack});

  List<RoutePageRouter> generatorRoutes();
}

class RoutePageRouter{
  final String path;
  final WidgetFunc widgetFunc;

  RoutePageRouter({@required this.path, @required this.widgetFunc});
}

typedef Widget WidgetFunc(String path);