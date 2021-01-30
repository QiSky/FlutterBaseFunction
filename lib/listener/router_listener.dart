import 'package:base_plugin/manager/route_manager.dart';
import 'package:flutter/widgets.dart';

class RouterListener extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    print("popPage => ${route.settings.name}");
    if (route.settings.name != null) {
      String path = RouteManager.instance.routerStack.removeLast();
      RouteManager.instance.paramsMap.remove(path);
    }
  }

  @override
  void didPush(Route route, Route previousRoute) {
    print("pushPage => ${route.settings.name}");
    if (route.settings.name != null)
      RouteManager.instance.routerStack.add(route.settings.name);
  }
}
