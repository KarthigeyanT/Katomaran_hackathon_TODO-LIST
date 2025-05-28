import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 50,
      printEmojis: true,
    ),
  );

  // Log file handling
  static const String _logFileName = 'app_logs.txt';
  static File? _logFile;
  static const int _maxLogFileSize = 5 * 1024 * 1024; // 5MB
  static const int _maxLogFiles = 3;

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal() {
    _initLogFile();
    // Set up global error handling
    _setupErrorHandling();
  }

  Future<void> _initLogFile() async {
    try {
      // Check if the platform supports file logging
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final directory = await _getLogDirectory();
        _logFile = File('${directory.path}/$_logFileName');

        // Rotate logs if file is too big
        if (await _logFile!.exists()) {
          final length = await _logFile!.length();
          if (length > _maxLogFileSize) {
            await _rotateLogs();
          }
        } else {
          await _logFile!.create(recursive: true);
        }
      } else {
        _logger.w('File logging is not supported on this platform.');
      }
    } catch (e) {
      _logger.e('Failed to initialize log file: $e');
    }
  }

  Future<Directory> _getLogDirectory() async {
    final directory = Directory('${Directory.current.path}/logs');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<void> _rotateLogs() async {
    try {
      final directory = await _getLogDirectory();
      final logFiles = await directory
          .list()
          .where((entity) => entity.path.endsWith('.txt'))
          .toList();

      // Sort files by modification time
      logFiles.sort((a, b) =>
          (b.statSync().modified).compareTo(a.statSync().modified));

      // Delete oldest files if we have too many
      for (var i = _maxLogFiles - 1; i < logFiles.length; i++) {
        await logFiles[i].delete();
      }

      // Rename current log file with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final newPath = '${directory.path}/app_logs_$timestamp.txt';
      await _logFile!.rename(newPath);
      _logFile = File('${directory.path}/$_logFileName');
      await _logFile!.create();
    } catch (e) {
      _logger.e('Failed to rotate logs: $e');
    }
  }

  Future<void> _writeToLogFile(String message) async {
    try {
      if (_logFile == null) {
        _logger.w('Log file is not initialized. Skipping file write.');
        return;
      }
      final timestamp = DateTime.now().toIso8601String();
      await _logFile!.writeAsString('$timestamp - $message\n', mode: FileMode.append);
    } catch (e) {
      _logger.e('Failed to write to log file: $e');
    }
  }

  void _setupErrorHandling() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.e('Flutter Error: ${details.exception}',
          error: details.exception, stackTrace: details.stack);
      _writeToLogFile(
          'FLUTTER ERROR: ${details.exception}\n${details.stack ?? 'No stack trace'}');
    };

    // Handle Dart errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.e('Uncaught error: $error', error: error, stackTrace: stack);
      _writeToLogFile('UNCAUGHT ERROR: $error\n$stack');
      return true; // Prevents the error from being handled again
    };
  }

  // Log methods
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    _writeToLogFile('DEBUG: $message');
  }

  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    _writeToLogFile('INFO: $message');
  }

  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    _writeToLogFile('WARNING: $message');
  }

  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    _writeToLogFile('ERROR: $message\n${error ?? ''}\n${stackTrace ?? ''}');
  }

  // Clear all log files
  Future<void> clearLogs() async {
    try {
      final directory = await _getLogDirectory();
      final logFiles = await directory
          .list()
          .where((entity) => entity.path.endsWith('.txt'))
          .toList();

      for (var file in logFiles) {
        await file.delete();
      }
      
      // Reinitialize log file
      await _initLogFile();
      i('Logs cleared successfully');
    } catch (e) {
      _logger.e('Failed to clear logs: $e');
      rethrow;
    }
  }

  // Get logs as string
  Future<String> getLogs() async {
    try {
      if (_logFile == null) {
        await _initLogFile();
      }
      if (await _logFile!.exists()) {
        return await _logFile!.readAsString();
      }
      return 'No logs available';
    } catch (e) {
      _logger.e('Failed to read logs: $e');
      return 'Error reading logs: $e';
    }
  }
}

// Global logger instance
final logger = AppLogger();
