import 'package:logger/logger.dart';

Logger Log = Logger(
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
