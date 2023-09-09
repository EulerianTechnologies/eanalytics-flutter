import 'package:logger/logger.dart';

class EALogger {
  static final EALogger _instance = EALogger._internal();
  static final prefix = '[EAnalytics] - ';
  static final logger = Logger(
      printer: PrettyPrinter(
          printEmojis: true,
          printTime: true,
          errorMethodCount: 0,
          methodCount: 0));

  EALogger._internal();

  factory EALogger() {
    return _instance;
  }

  static void setLevel(Level level) {
    Logger.level = level;
  }

  void info(String message) {
    EALogger.logger.i('${EALogger.prefix}$message');
  }

  void debug(String message) {
    EALogger.logger.d('${EALogger.prefix}$message');
  }

  void trace(String message) {
    EALogger.logger.t('${EALogger.prefix}$message');
  }

  void error(String message) {
    EALogger.logger.e('${EALogger.prefix}$message');
  }
}
