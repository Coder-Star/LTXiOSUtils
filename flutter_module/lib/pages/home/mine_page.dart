import 'package:flutter/cupertino.dart';

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MineWidgetState();
  }
}

class MineWidgetState extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("我")),
      child: new Center(
        child: Icon(CupertinoIcons.tortoise_fill,size: 130.0,color: CupertinoColors.systemBlue),
      ),
    );
  }
}