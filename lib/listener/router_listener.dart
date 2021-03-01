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
    RouteManager.instance.printRouteStack(description: "Listen After the operate:");
  }

  @override
  void didPush(Route route, Route previousRoute) {
    print("pushPage => ${route.settings.name}");
    if (route.settings.name != null)
      RouteManager.instance.routerStack.add(route.settings.name);
    RouteManager.instance.printRouteStack(description: "Listen After the operate:");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("deletePage => ${route.settings.name}");
    RouteManager.instance.routerStack.removeWhere((element) => route.settings.name == element);
    RouteManager.instance.printRouteStack(description: "Listen After the operate:");
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print("replacePage => ${oldRoute.settings.name}, toPage => ${newRoute.settings.name}");
    if (oldRoute.settings.name != null){
      String path = RouteManager.instance.routerStack.removeLast();
      RouteManager.instance.paramsMap.remove(path);
      RouteManager.instance.routerStack.add(newRoute.settings.name);
    }
    RouteManager.instance.printRouteStack(description: "Listen After the operate:");
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) { }

  @override
  void didStopUserGesture() { }
}
