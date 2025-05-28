import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, debugPrint;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LogEntry {
  final DateTime timestamp;
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;
  final Level level;

  LogEntry({
    required this.message,
    this.error,
    this.stackTrace,
    required this.level,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '${timestamp.toIso8601String()} [${level.name}] $message';
  }
}

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
  
  final List<LogEntry> _logs = [];
  File? _logFile;
  
  List<LogEntry> get logs => List.unmodifiable(_logs);
  
  AppLogger._internal() {
    // Only initialize file logging on mobile platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _initLogFile();
    }
  }
  
  Future<void> _initLogFile() async {
    try {
      final directory = await path_provider.getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/app_log.txt');
      await _logFile?.create(recursive: true);
      await _logFile?.writeAsString('--- Log Started at ${DateTime.now()} ---\n', mode: FileMode.append);
    } catch (e) {
      // Only log file init errors in debug mode to avoid console spam
      if (kDebugMode) {
        debugPrint('Logger: File logging disabled - $e');
      }
    }
  }
  
  Future<void> _writeToLogFile(String message) async {
    // Skip if not on mobile or file not initialized
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS) || _logFile == null) {
      return;
    }
    
    try {
      await _logFile?.writeAsString('${DateTime.now()}: $message\n', mode: FileMode.append);
    } catch (e) {
      // Only log write errors in debug mode to avoid console spam
      if (kDebugMode) {
        debugPrint('Logger: Failed to write to log file - $e');
      }
    }
  }

  static Future<void> log(Level level, dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    try {
      final logMessage = message.toString();
      final entry = LogEntry(
        message: logMessage,
        error: error,
        stackTrace: stackTrace,
        level: level,
      );
      
      // Add to in-memory logs
      _instance._logs.add(entry);
      
      // Limit the number of stored logs to prevent memory issues
      if (_instance._logs.length > 1000) {
        _instance._logs.removeAt(0);
      }
      
      // Only log to file on supported platforms (not web)
      if (!kIsWeb && _instance._logFile != null) {
        try {
          await _instance._writeToLogFile('${level.name.toUpperCase()}: $logMessage');
          if (error != null) {
            await _instance._writeToLogFile('Error: $error');
          }
          if (stackTrace != null) {
            await _instance._writeToLogFile('Stack trace: $stackTrace');
          }
        } catch (e) {
          print('Logger: Failed to write to log file: $e');
        }
      }
      
      // Only print logs in debug mode
      if (kDebugMode) {
        final logger = _logger;
        final errorMessage = error != null ? 'Error: $error' : '';
        final stackTraceStr = stackTrace != null ? '\n$stackTrace' : '';
        final fullMessage = '$logMessage$errorMessage$stackTraceStr';
        
        // Handle all log levels including Level.all
        if (level == Level.verbose || level == Level.all) {
          logger.v(fullMessage);
        } else if (level == Level.debug) {
          logger.d(fullMessage);
        } else if (level == Level.info) {
          logger.i(fullMessage);
        } else if (level == Level.warning) {
          logger.w(fullMessage);
        } else if (level == Level.error) {
          logger.e(fullMessage);
        } else if (level == Level.wtf) {
          logger.wtf(fullMessage);
        } else {
          // Default to verbose for any other level
          logger.v(fullMessage);
        }
      }
    } catch (e) {
      // If logging fails, at least print to console
      print('Error in logger: $e');
    }
  }

  static Future<void> t(dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    await log(Level.verbose, message, error, stackTrace);
  }

  static Future<void> d(dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    await log(Level.debug, message, error, stackTrace);
  }

  static Future<void> i(dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    await log(Level.info, message, error, stackTrace);
  }

  static Future<void> w(dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    await log(Level.warning, message, error, stackTrace);
  }

  static Future<void> e(dynamic message, [dynamic error, StackTrace? stackTrace]) async {
    await log(Level.error, message, error, stackTrace);
    
    // In debug mode, print detailed error information
    if (kDebugMode && (error != null || stackTrace != null)) {
      print('ERROR: $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
  }

  /// Logs a fatal error. Replaces deprecated wtf with f (Level.fatal).
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    
    // In debug mode, print detailed fatal error information
    if (kDebugMode) {
      print('FATAL ERROR: $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
  }

}
