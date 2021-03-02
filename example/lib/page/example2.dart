
import 'package:base_plugin/manager/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Example2Widget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Example2State();
  }

}

class Example2State extends State<Example2Widget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("实例2的初始化");
  }
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("实例2跳转到实例3"),
        onPressed: (){
          RouteManager.instance.navigateTo(context, "/example3",replace: true);
        });
  }

}