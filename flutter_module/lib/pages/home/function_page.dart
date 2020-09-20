import 'package:flutter/material.dart';

class FunctionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new FunctionWidgetState();
  }
}

class FunctionWidgetState extends State<FunctionPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('功能'),
      ),
      body: new Center(
        child: Icon(Icons.apps_sharp,size: 130.0,color: Colors.blue,),
      ),
    );
  }
}