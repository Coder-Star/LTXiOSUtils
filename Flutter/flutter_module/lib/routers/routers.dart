import 'package:fluro/fluro.dart';
import 'package:flutter_module/routers/route_handler.dart';

/// 路由管理
class Routers {
  /// 根路由
  static final root = '/';

  /// FluroRouter
  static FluroRouter router;

  /// flutter_channel
  static final flutterChannel = '/flutter_channel';

  /// component_list
  static final componentList = '/component_list';

  /// 配置路由地址与其对应回调
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notFoundHandler;
    router.define(root, handler: rootHandler);
    router.define(flutterChannel, handler: flutterChannelHandler);
    router.define(componentList, handler: componentListHandler);
  }
}
