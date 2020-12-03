/// ChannelUtils
class ChannelUtils {
  /// Android包名
  static const packageName = 'com.star.LTXiOSUtils';

  /// iOS包名
  static const bundleID = 'com.star.LTXiOSUtils';

  /// 获取Channel名称
  static String getChannelName(ChannelType type, {String channelName}) {
    final tempChannelName =
        bundleID + '/' + type.toString().split('.')[1] + '/app';
    if (channelName.isNotEmpty) {
      return tempChannelName + '/' + channelName;
    } else {
      return tempChannelName;
    }
  }
}

/// Channel类型
enum ChannelType {
  /// method
  method,

  /// event
  event,

  /// basicMessage
  basicMessage,
}
