import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_module/utils/channel_utils.dart';

/// flutte端相关实现，方便院原生调用

final eventChannel = EventChannel(ChannelUtils.getChannelName(ChannelType.event,
    channelName: 'testEventChannel'));

/// 注册
class FlutterHanlder {
  ///
  static void initFlutterHander() {
    initMethodHander();
    initEventHander();
    initMessageHander();
  }

  /// 方法类型实现
  static void initMethodHander() {
    final methodChannel = MethodChannel(ChannelUtils.getChannelName(
        ChannelType.method,
        channelName: 'testMethodChannel'));
    methodChannel.setMethodCallHandler(_methodCallHander);
  }

  static Future<dynamic> _methodCallHander(MethodCall call) async {
    print(call);
    switch (call.method) {
      case 'callFlutter':
        return '来自Flutter的回复';
    }
  }

  /// 消息类型实现
  static void initMessageHander() {
    final basicMessageChannel = BasicMessageChannel(
        ChannelUtils.getChannelName(ChannelType.basicMessage,
            channelName: 'testMessageChannel'),
        StringCodec());
    basicMessageChannel.setMessageHandler(_messageHandler);
  }

  static Future<String> _messageHandler(String message) async {
    print(message);
    return '来自Flutter的messageHandler';
  }

  /// Event类型实现
  static void initEventHander() {
    eventChannel.receiveBroadcastStream().listen((event) {
      EasyLoading.showToast(event as String);
    });
  }
}
