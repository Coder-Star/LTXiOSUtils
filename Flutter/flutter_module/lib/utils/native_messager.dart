import 'package:flutter/services.dart';

import 'channel_utils.dart';

///
class NativeMessager {
  /// 调用原生方法
  ///
  /// * channel: channel名称
  /// * method: 方法名称
  /// * para: 参数
  static Future<dynamic> callNativeMethod(
      String channel, String method, para) async {
    final methodChannel = MethodChannel(ChannelUtils.getChannelName(
      ChannelType.method,
      channelName: channel,
    ));
    try {
      // 将异步变同步，否则拿不到返回值
      final result = await methodChannel.invokeMethod(method, para);
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  ///
  static dynamic callNativeMessage(String channel, String message) async {
    final messageChannel = BasicMessageChannel(
        ChannelUtils.getChannelName(ChannelType.basicMessage,
            channelName: channel),
        StringCodec());
    final result = await messageChannel.send(message);
    print(result.toString());
    return result;
  }
}
