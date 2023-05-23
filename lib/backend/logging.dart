import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Logging {
  factory Logging() {
    return _singleton;
  }

  Logging._internal();

  final logger = Logger(
    // use simple printer during release
    printer: !kReleaseMode ? PrettyPrinter() : SimplePrinter(),
    filter: CustomFilter(),
  );

  static final _singleton = Logging._internal();
}

class CustomFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // this is in release mode only
    if (kReleaseMode) {
      // if the log level is debug or verbose then return false, else return true
      if (event.level == Level.verbose || event.level == Level.debug) {
        return false;
      }
      return true;
    }

    // if in debug mode then allow all log levels
    return true;
  }
}
