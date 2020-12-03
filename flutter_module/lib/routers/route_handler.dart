import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_module/pages/demo/component_list.dart';
import 'package:flutter_module/pages/demo/flutter_channel.dart';
import 'package:flutter_module/utils/log_utils.dart';
import 'package:flutter_module/widgets/page_not_found.dart';

import '../main.dart';

/// 路由找不到时对应回调
var notFoundHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  Log.logger.d('未找到路由');
  return PageNotFound();
});

///
var rootHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return BottomNavigationWidget();
});

///
var flutterChannelHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  Log.logger.d(context.settings);
  return FlutterChannel();
});

///
var componentListHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ComponentList();
});
