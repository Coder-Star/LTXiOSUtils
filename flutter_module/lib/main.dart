import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/pages/home/function_page.dart';
import 'package:flutter_module/pages/home/mine_page.dart';
import 'package:flutter_module/pages/home/widgets_list_page.dart';
import 'package:flutter_module/routers/routers.dart';
import 'package:flutter_module/themes/theme_color.dart';
import 'package:flutter_module/utils/futter_handler.dart';

// main方法是flutter的入口
void main() {
  // 捕获dart异常
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
    FlutterHanlder.initFlutterHander();
  }, (Object error, StackTrace stack) async {
    print(error);
    print(stack);
  });

  // 捕获Flutter异常
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    print(errorDetails);
  };
}

///
class MyApp extends StatefulWidget {
  ///
  MyApp() {
    final router = FluroRouter.appRouter;
    Routers.router = router;
    // 配置fluro路由
    Routers.configureRoutes(router);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 不显示debug标志
      showPerformanceOverlay: false,
      home: BottomNavigationWidget(),
      theme: ThemeData(
        primaryColor: ThemeColor.mainColor, //主题色
      ),
      builder: (BuildContext context, Widget child) {
        /// 确保 loading 组件能覆盖在其他组件之上.
        return FlutterEasyLoading(child: child);
      },
      onGenerateRoute: Routers.router.generator,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

///
class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavigationWidgetState();
  }
}

///
class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _normalColor = Colors.black12;
  final _selectedColor = ThemeColor.mainColor;
  final _pages = [WidgetsListPage(), FunctionPage(), MinePage()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.widgets,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.widgets,
                color: _selectedColor,
              ),
              label: 'widgets'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.apps_sharp,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.apps_sharp,
                color: _selectedColor,
              ),
              label: '功能'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                color: _normalColor,
              ),
              activeIcon: Icon(
                Icons.account_box,
                color: _selectedColor,
              ),
              label: '我'),
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
      body: _pages[_currentIndex],
    );
  }
}
