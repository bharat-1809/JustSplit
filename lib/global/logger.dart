import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    errorMethodCount: 3,
    lineLength: 50,
    methodCount: 0,
    printEmojis: true,
    printTime: false,
  ),
);
