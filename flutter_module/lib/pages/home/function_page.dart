
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/utils/NativeMessager.dart';

class FunctionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var items = new List<Map>();
    const item1 = {"code": "methodChannel", "title": "methodChannel调用Native"};
    const item2 = {"code": "eventChannel", "title": "eventChannel调用Native"};
    items.add(item1);
    items.add(item2);
    return new FunctionWidgetState(items);
  }
}

class FunctionWidgetState extends State<FunctionPage> {
  final List<Map> items;

  // 构造函数
  FunctionWidgetState(this.items);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('功能'),
        ),
        body: new ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return getItem(index);
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: Colors.grey)));
  }

  Widget getItem(int index) {
    return GestureDetector(
      child: ListTile(
        title: new Text('${items[index]["title"]}'),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
      onTap: (){
        setState(() {
          clickItem(index);
        });
      },
      onLongPress: (){
        EasyLoading.showToast("长按");
      }
    );
  }

  void clickItem(int index) {
    String code = items[index]["code"];
    switch(code) {
      case "methodChannel": {
        NativeMessager.callNativeMethod("testMethodChannel", "callNativeMethond", {"key": "flutter"});
        EasyLoading.showToast(code);
      }
      break;
      case "eventChannel": {
        NativeMessager.callNativeMethod("testMethodChannel", "callNativeMethond", {"key": "flutter"});
        EasyLoading.showToast(code);
      }
      break;

      default: {

      }
      break;
    }

  }
}
