import 'package:logger/logger.dart';

/// 日志
class Log {
  /// 日志工具
  static var logger = Logger(
    filter: null,
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 1,
      lineLength: 80,
      printTime: false,
      colors: true,
      printEmojis: true,
    ),
    output: null,
  );
}
