import 'package:logger/logger.dart';

/// Logger class to use logger everywhere in the project
class AppLogger {
  /// Private constructor
  AppLogger._internal() {
    _logger = Logger();
  }

  /// Singleton instance
  static final AppLogger _instance = AppLogger._internal();

  /// Logger instance
  late Logger _logger;

  /// Get the singleton instance of AppLogger
  static AppLogger get instance => _instance;

  /// Get the logger instance
  Logger get logger => _logger;
}

/// Short-hand global logger for easy access
final logger = AppLogger.instance.logger;