import 'package:flutter/material.dart';

import 'package:flutter_module/themes/theme_color.dart';
import 'package:flutter_module/pages/home/index_page.dart';
import 'package:flutter_module/pages/home/function_page.dart';
import 'package:flutter_module/pages/home/mine_page.dart';

// main方法是flutter的入口
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 不显示debug标志
      showPerformanceOverlay: false,
      home: BottomNavigationWidget(),
      theme: ThemeData(
          primaryColor: ThemeColor.mainColor //主题色
      ),
    );
  }
}

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavigationWidgetState();
  }
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _normalColor = Colors.black12;
  final _selectedColor = ThemeColor.mainColor;
  final pages = [IndexPage(), FunctionPage(), MinePage()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.home,
                color: _selectedColor,
              ),
              label: "首页"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.apps_sharp,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.apps_sharp,
                color: _selectedColor,
              ),
              label: "功能"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.account_box,
                color: _selectedColor,
              ),
              label: "我"),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
//        fixedColor: _selectedColor,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}
