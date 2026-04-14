import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO]  $message');
  }

  static void error(String message, [Object? e]) {
    if (kDebugMode) debugPrint('[ERROR] $message${e != null ? ' | $e' : ''}');
  }

  static void warn(String message) {
    if (kDebugMode) debugPrint('[WARN]  $message');
  }
}
