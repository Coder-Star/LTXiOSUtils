import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_module/constant/common_lib.dart';
import 'package:flutter_module/pages/demo/common/dialog_demo.dart';
import 'package:flutter_module/resources/icon_font.dart';

///
class WidgetsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetsListPageState();
  }
}

class _WidgetsListPageState extends State<WidgetsListPage> {
  static final List _commonList = [
    {'code': 'Dialog', 'title': 'Dialog'},
  ];

  static final List _iOSList = [
    {'code': 'iOS', 'title': 'iOS'},
  ];
  static final List _androidList = [
    {'code': 'Android', 'title': 'Android'},
  ];

  final _allList = [..._commonList, ..._iOSList, ..._androidList];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widgets'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _allList.length,
        itemBuilder: (context, index) {
          var code = (_allList[index] as Map)['code'] as String;
          var title = (_allList[index] as Map)['title'] as String;
          if (['Android', 'iOS'].contains(code)) {
            Widget icon;
            if (code == 'Android') {
              icon = Icon(
                IconFonts.android,
                color: ColorExtension.hexToColor('#98bd66'),
              );
            } else if (code == 'iOS') {
              icon = Image.asset(
                'assets/images/widgets/icon_ios.png',
                width: 30,
                height: 30,
              );
            }
            return ListTile(
              key: Key(code),
              title: Text(
                title,
                style: TextStyle(
                    fontFamily: ThemeFont.fangZhengMiaoWu, fontSize: 30),
              ),
              minLeadingWidth: 0,
              leading: icon,
              onTap: () {
                _clickItem(code);
              },
            );
          }
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
    );
  }

  void _clickItem(String code) {
    Log.d(code);
    switch (code) {
      case 'Dialog':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => DialogDemo()));
        break;
      default:
        break;
    }
  }
}
