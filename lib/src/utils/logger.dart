import 'package:logger/logger.dart';

class EALogger {
  static final logger = Logger(
      printer: PrettyPrinter(
          colors: true,
          printEmojis: true,
          printTime: true,
          lineLength: 80,
          errorMethodCount: 0,
          methodCount: 0));
  static final EALogger _instance = EALogger._internal();
  static final prefix = '[EAnalytics] - ';

  EALogger._internal();

  factory EALogger() {
    return _instance;
  }

  void info(String message) {
    EALogger.logger.i('${EALogger.prefix}$message');
  }

  void debug(String message) {
    EALogger.logger.d('${EALogger.prefix}$message');
  }

  void verbose(String message) {
    EALogger.logger.v('${EALogger.prefix}$message');
  }

  void error(String message) {
    EALogger.logger.e('${EALogger.prefix}$message');
  }
}
