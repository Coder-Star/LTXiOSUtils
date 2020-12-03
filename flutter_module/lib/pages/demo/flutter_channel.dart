import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/utils/log_utils.dart';
import 'package:flutter_module/utils/native_messager.dart';

///
class FlutterChannel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var items = <Map>[];
    const item1 = {'code': 'methodChannel', 'title': 'methodChannel调用Native'};
    const item2 = {'code': 'eventChannel', 'title': 'eventChannel调用Native'};
    const item3 = {'code': 'messageChannel', 'title': 'messageChannel调用Native'};
    items.add(item1);
    items.add(item2);
    items.add(item3);
    return FunctionWidgetState(items);
  }
}

///
class FunctionWidgetState extends State<FlutterChannel> {
  final List<Map> _items;

  /// 构造函数
  FunctionWidgetState(this._items);

  @override
  Widget build(BuildContext context) {
    // 获取页面传递过来的参数
    final args = ModalRoute.of(context).settings;
    Log.logger.e(args);
    return Scaffold(
        appBar: AppBar(
          title: Text((args.arguments as Map<String, String>)['title']),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pop('从FlutterChannel返回的信息');
              },
            )
          ],
        ),
        body: ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _getItem(index);
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: Colors.grey)));
  }

  Widget _getItem(int index) {
    return GestureDetector(
        child: ListTile(
          title: Text('${_items[index]["title"]}'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        onTap: () {
          setState(() {
            _clickItem(index);
          });
        },
        onLongPress: () {
          EasyLoading.showToast('长按');
        });
  }

  Future<void> _clickItem(int index) async {
    var code = _items[index]['code'] as String;
    switch (code) {
      case 'methodChannel':
        Log.logger.e('123');
        final message = await NativeMessager.callNativeMethod(
          'testMethodChannel',
          'callNativeMethond',
          {'key': 'flutter'},
        );
        await EasyLoading.showToast(message as String);
        break;
      case 'eventChannel':
        await NativeMessager.callNativeMethod(
          'testMethodChannel',
          'callNativeMethond',
          {'key': 'flutter'},
        );
        await EasyLoading.showToast(code);
        break;
      case 'messageChannel':
        final message = await NativeMessager.callNativeMessage(
          'testMessageChannel',
          '来自Flutter的消息',
        );
        await EasyLoading.showToast(message as String);
        break;
      default:
        break;
    }
  }
}
