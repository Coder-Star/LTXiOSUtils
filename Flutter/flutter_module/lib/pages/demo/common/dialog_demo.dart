import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/constant/common_lib.dart';

///
class DialogDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DialogDemoState();
  }
}

class _DialogDemoState extends State<DialogDemo> {
  static final List _allList = [
    {'code': 'CupertinoAlertDialog', 'title': 'CupertinoAlertDialog'},
    {'code': 'CupertinoActionSheet', 'title': 'CupertinoActionSheet'},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 拦截返回按钮事件
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dialog'),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _allList.length,
          itemBuilder: (context, index) {
            var code = (_allList[index] as Map)['code'] as String;
            var title = (_allList[index] as Map)['title'] as String;
            return Card(
              child: ListTile(
                key: Key(code),
                title: Text(
                  title,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  _clickItem(code);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _clickItem(String code) {
    Log.d(code);
    switch (code) {
      case 'CupertinoAlertDialog':
        showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('这是标题标题标题标题标题标题标题'),
                content: Text('这是内容，很长很长很长很长很长很长很长很长'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop('点击了确定');
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('确定'),
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop('点击了确定');
                    },
                  ),
                ],
              );
            });
        break;
      case 'CupertinoActionSheet':
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text('提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示'),
                message: Text('是否要删除删除删除删除删除删除删除删除删除删除删除删除当前项？'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text('删除'),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    child: Text('暂时不删'),
                    onPressed: () {},
                    isDestructiveAction: true,
                  ),
                ],
              );
            });
        break;
      default:
        break;
    }
  }
}
