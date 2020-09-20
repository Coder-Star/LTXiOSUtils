import 'package:flutter/material.dart';

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MineWidgetState();
  }
}

class MineWidgetState extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('我'),
      ),
      body: new Center(
        child: Icon(Icons.account_box,size: 130.0,color: Colors.blue,),
      ),
    );
  }
}