import 'package:flutter/material.dart';

/// 使用 main() 以外的 Dart 入口函数，必须使用下面的注解，
/// 防止被 tree-shaken 优化掉，而没有编译
@pragma('vm:entry-point')
void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('这里是flutter_star的首页'),
      ),
      body: Center(
        child: Text('这是内容'),
      ),
    );
  }
}
