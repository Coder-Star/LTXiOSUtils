import 'package:flutter/cupertino.dart';
import 'package:flutter_module/themes/theme_color.dart';

///
class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineWidgetState();
  }
}

///
class MineWidgetState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('我')),
      child: Center(
        child: Icon(
          CupertinoIcons.tortoise_fill,
          size: 130.0,
          color: ThemeColor.mainColor,
        ),
      ),
    );
  }
}
