import 'package:flutter/material.dart';
import 'package:flutter_module/extension/color_extension.dart';
import 'package:flutter_module/resources/icon_font.dart';

///
class WidgetsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WidgetsListPageState();
  }
}

class _WidgetsListPageState extends State<WidgetsListPage> {
  List<ListTile> items = [
    ListTile(
      key: Key('iOS'),
      title: Text('iOS'),
      trailing: Icon(Icons.keyboard_arrow_right),
      minLeadingWidth: 0,
      leading: Image.asset(
        'assets/images/widgets/icon_ios.png',
        width: 30,
        height: 30,
      ),
    ),
    ListTile(
      key: Key('ComponentList'),
      title: Text('ComponentList'),
      trailing: Icon(Icons.keyboard_arrow_right),
      minLeadingWidth: 0,
      leading: Icon(
        IconFonts.android,
        color: ColorExtension.hexToColor('#98bd66'),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widgets'),
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
          );
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
      case 'FlutterChannel':
        break;
      case 'ComponentList':
        break;
      default:
        break;
    }
  }
}
