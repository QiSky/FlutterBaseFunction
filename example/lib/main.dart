import 'dart:convert';

import 'package:base_plugin/listener/router_listener.dart';
import 'package:base_plugin/manager/route_manager.dart';
import 'package:base_plugin_example/page/example1.dart';
import 'package:base_plugin_example/page/example2.dart';
import 'package:base_plugin_example/page/example3.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final routerListener = RouterListener();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteManager.instance.router.generator,
      initialRoute: "/example1",
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routerListener]
    );
  }
}
