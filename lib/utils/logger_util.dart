import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
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
  static final AppLogger instance = AppLogger._internal();
  final Logger _logger;
  final List<LogEntry> _logs = [];
  File? _logFile;

  AppLogger._internal()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            printTime: false,
          ),
        ) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _initLogFile();
    }
  }

  factory AppLogger() => instance;

  static void log(Level level, String message, [dynamic error, StackTrace? stackTrace]) {
    try {
      instance._logger.log(level, message, error: error, stackTrace: stackTrace);
      instance._addToLogs(level, message, error, stackTrace);
    } catch (e) {
      debugPrint('Logger error: $e');
    }
  }

  List<LogEntry> get logs => List.unmodifiable(_logs);

  void _addToLogs(Level level, String message, dynamic error, StackTrace? stackTrace) {
    try {
      _logs.add(LogEntry(
        message: message,
        error: error,
        stackTrace: stackTrace,
        level: level,
      ));

      if (_logs.length > 1000) {
        _logs.removeAt(0);
      }

      _writeToLogFile(level, message, error, stackTrace);
    } catch (e) {
      debugPrint('Error in _addToLogs: $e');
    }
  }

  Future<void> _initLogFile() async {
    try {
      final directory = await path_provider.getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/app_logs.txt');
      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }
      await _logFile!.writeAsString('--- Log Started at ${DateTime.now()} ---\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('Error initializing log file: $e');
    }
  }

  Future<void> _writeToLogFile(Level level, String message, dynamic error, StackTrace? stackTrace) async {
    if (_logFile == null) return;

    try {
      final entry = LogEntry(
        message: message,
        error: error,
        stackTrace: stackTrace,
        level: level,
      );

      await _logFile!.writeAsString(
        '${entry.timestamp} [${entry.level.name.toUpperCase()}] $message\n',
        mode: FileMode.append,
      );
    } catch (e) {
      debugPrint('Error writing to log file: $e');
    }
  }
}
