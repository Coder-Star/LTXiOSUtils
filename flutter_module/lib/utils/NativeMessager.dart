
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NativeMessager {
  // Android包名
  static const packageName = "com.star.LTXiOSUtils";
  // iOS包名
  static const bundleID = "com.star.LTXiOSUtils";

  static String getChannelName(ChannelType type, {String channelName}) {
     final tempChannelName = bundleID + "/" + type.toString().split(".")[1] + "/app";
     if (channelName.isNotEmpty) {
        return tempChannelName + "/" + channelName;
     } else {
        return tempChannelName;
     }
  }

  /// 调用原生方法
  ///
  /// * channel: channel名称
  /// * method: 方法名称
  /// * para: 参数
  static Future<dynamic> callNativeMethod(String channel, String method, para) async {
    final methodChannel = MethodChannel(getChannelName(ChannelType.method, channelName: channel));
    try {
      final result = await methodChannel.invokeMethod(method, para);
      EasyLoading.showToast(result.toString());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

}


enum ChannelType {
 method,
 event,
 basicMessage
}