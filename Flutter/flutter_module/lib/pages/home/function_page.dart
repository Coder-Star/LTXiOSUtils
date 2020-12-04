import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/constant/common_lib.dart';
import 'package:flutter_module/routers/routers.dart';

///
class FunctionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FunctionWidgetState();
  }
}

class _FunctionWidgetState extends State<FunctionPage> {
  List<ListTile> items = [
    ListTile(
      key: Key('FlutterChannel'),
      title: Text('FlutterChannel'),
      trailing: Icon(Icons.keyboard_arrow_right),
    ),
    ListTile(
      key: Key('ComponentList'),
      title: Text('ComponentList'),
      trailing: Icon(Icons.keyboard_arrow_right),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('功能'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Card(
                child: items[index],
              ),
              onTap: () {
                setState(() {
                  clickItem(items[index].key.toString());
                });
              },
              onLongPress: () {
                EasyLoading.showToast('长按');
              });
        },
      ),
    );
  }

  void clickItem(String code) {
    code = code
        .replaceAll("'", '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('<', '')
        .replaceAll('>', '');
    switch (code) {
      // FlutterChannel
      case 'FlutterChannel':
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => FlutterChannel(),
        //         settings: RouteSettings(name: "路由名称", arguments: "这是参数")));

        // final result = Navigator.pushNamed(context, "/flutter_channel",
        //     arguments: "从功能页传过来的参数");
        // result.then((value) {
        //   // 页面返回回传的参数
        //   Log.logger.d(value);
        // });

        // Routers.router
        //     .navigateTo(context, Routers.flutterChannel + "/标题：flutterChannel",
        //         transition: TransitionType.native)
        //     .then(
        //       (value) => {
        //         // 页面返回回传的参数
        //         Log.logger.d(value)
        //       },
        //     );
        Routers.router
            .navigateTo(
              context,
              Routers.flutterChannel,
              transition: TransitionType.native,
              routeSettings: RouteSettings(
                arguments: {'title': '标题'},
              ),
            )
            .then(
              (value) => Log.e(value),
            );
        break;
      // ComponentList
      case 'ComponentList':
        break;
      default:
        break;
    }
  }
}
