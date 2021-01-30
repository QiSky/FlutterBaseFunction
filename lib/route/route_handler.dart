import 'package:base_plugin/route/route_page_routers.dart';

///路由解析
class RouteHandler extends RoutePageRouters {
  List<RoutePageRouter> routeList;

  @override
  List<RoutePageRouter> generatorRoutes() {
    assert(routeList != null);
    return routeList;
  }

  @override
  void insertRoutes({List<RoutePageRouter> list, Function insertCallBack}) {
    if (list != null && list.isNotEmpty) {
      routeList.addAll(list);
      return;
    }
    insertCallBack(routeList);
  }
}
