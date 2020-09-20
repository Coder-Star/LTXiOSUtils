import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new IndexWidgetState();
  }
}

class IndexWidgetState extends State<IndexPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('首页'),
      ),
      body: new Center(
        child: Icon(Icons.home,size: 130.0,color: Colors.blue,),
      ),
    );
  }
}