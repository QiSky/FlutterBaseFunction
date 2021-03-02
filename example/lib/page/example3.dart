
import 'package:base_plugin/manager/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Example3Widget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Example3State();
  }

}

class Example3State extends State<Example3Widget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("实例3的初始化");
  }
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("实例3跳转到实例1"),
        onPressed: (){
          RouteManager.instance.navigateTo(context, "/example2",clearStack: true);
        });
  }

}