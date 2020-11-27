
class ChannelUtils {
  // Android包名
  static const packageName = "com.star.LTXiOSUtils";

  // iOS包名
  static const bundleID = "com.star.LTXiOSUtils";

  static String getChannelName(ChannelType type, {String channelName}) {
    final tempChannelName = bundleID + "/" + type.toString().split(".")[1] +
        "/app";
    if (channelName.isNotEmpty) {
      return tempChannelName + "/" + channelName;
    } else {
      return tempChannelName;
    }
  }
}

enum ChannelType {
  method,
  event,
  basicMessage
}