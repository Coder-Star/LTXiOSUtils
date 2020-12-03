import 'package:flutter/material.dart';

/// 没有定义的路由对应页面
class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('404'),
        ),
        body: Center(child: Text('widget not found')));
  }
}
