import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be shown
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ),
  );

  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  @override
  void log(Level level, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    final logMessage = StringBuffer()..write(message);
    if (error != null) logMessage.write(' - Error: $error');
    
    _logger.log(level, logMessage.toString(), error: error, stackTrace: stackTrace);
  }

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    
    // Send non-fatal exception to Crashlytics
    if (error != null || stackTrace != null) {
      FirebaseCrashlytics.instance.recordError(
        error ?? Exception(message),
        stackTrace ?? StackTrace.current,
        reason: message.toString(),
        printDetails: true,
      );
    } else {
      FirebaseCrashlytics.instance.recordError(
        Exception(message),
        StackTrace.current,
        reason: 'Error logged without exception',
        printDetails: true,
      );
    }
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error: error, stackTrace: stackTrace);
    
    // Log as a fatal error in Crashlytics
    if (error != null || stackTrace != null) {
      FirebaseCrashlytics.instance.recordError(
        error ?? Exception(message),
        stackTrace ?? StackTrace.current,
        reason: 'FATAL: $message',
        fatal: true,
      );
    } else {
      FirebaseCrashlytics.instance.recordError(
        Exception('FATAL: $message'),
        StackTrace.current,
        reason: 'Fatal error logged without exception',
        fatal: true,
      );
    }
  }

  // Helper method to log to Crashlytics
  static void _logToCrashlytics(
    String level,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace, {
    bool isError = false,
    bool isFatal = false,
  }) {
    final logMessage = '[$level] $message';
    
    // Log the message
    FirebaseCrashlytics.instance.log(logMessage);
    
    // Record error if it's an error or fatal
    if (isError || isFatal) {
      final errorToReport = error ?? Exception(message);
      final stackToReport = stackTrace ?? StackTrace.current;
      
      FirebaseCrashlytics.instance.recordError(
        errorToReport,
        stackToReport,
        reason: logMessage,
        fatal: isFatal,
      );
    }
  }
}
