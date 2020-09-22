import 'package:flutter/material.dart';

class FunctionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var items = new List<Map>();
    const item1 = {"code": "widget", "title": "widget学习"};
    const item2 = {"code": "widget", "title": "widget学习"};
    items.add(item1);
    items.add(item2);
    return new FunctionWidgetState(items);
  }
}

class FunctionWidgetState extends State<FunctionPage> {
  final List<Map> items;

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
              return new ListTile(
                title: new Text('${items[index]["title"]}'),
                trailing: Icon(Icons.keyboard_arrow_right),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1.0, color: Colors.grey)));
  }
}
