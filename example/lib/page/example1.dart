
import 'package:base_plugin/manager/route_manager.dart';
import 'package:base_plugin/manager/timer_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Example1Widget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Example1State();
  }

}

class Example1State extends State<Example1Widget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("实例1的初始化");
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("实例1跳转到实例2"),
        onPressed: (){
      RouteManager.instance.navigateTo(context, "/example2");
    });
  }

}