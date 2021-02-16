import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/utils/channel_utils.dart';

/// 注册
class FlutterHanlder {
  ///
  static void initFlutterHander() {
    initMethodHander();
    // initEventHander();
    initMessageHander();
  }

  ///
  static void initMethodHander() {
    final methodChannel = MethodChannel(ChannelUtils.getChannelName(
        ChannelType.method,
        channelName: 'testMethodChannel'));
    methodChannel.setMethodCallHandler(methodCallHander);
  }

  /// 注册方法
  static Future<dynamic> methodCallHander(MethodCall call) async {
    print(call);
    switch (call.method) {
      case 'callFlutter':
        return '来自Flutter的回复';
    }
  }

  ///
  static void initMessageHander() {
    final basicMessageChannel = BasicMessageChannel(
        ChannelUtils.getChannelName(ChannelType.basicMessage,
            channelName: 'testMessageChannel'),
        StringCodec());
    basicMessageChannel.setMessageHandler(messageHandler);
  }

  /// 注册方法
  static Future<String> messageHandler(String message) async {
    print(message);
    return '来自Flutter的messageHandler';
  }

  ///
  static void initEventHander() {
    final eventChannel = EventChannel(ChannelUtils.getChannelName(
        ChannelType.event,
        channelName: 'testEventChannel'));
    eventChannel.receiveBroadcastStream().listen((event) {
      EasyLoading.showToast(event as String);
    });
  }
}
