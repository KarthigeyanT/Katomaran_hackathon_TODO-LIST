import 'package:flutter/material.dart';
import 'package:katomaran_hackathon/utils/logger_util.dart';
import 'package:logger/logger.dart' show Level;

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  _LogViewerScreenState createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showDebug = true;
  bool _showInfo = true;
  bool _showWarning = true;
  bool _showError = true;
  bool _showFatal = true;

  @override
  void initState() {
    super.initState();
    // Scroll to bottom when new logs are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Color _getLogColor(Level level) {
    switch (level) {
      case Level.debug:
        return Colors.blue;
      case Level.info:
        return Colors.green;
      case Level.warning:
        return Colors.orange;
      case Level.error:
        return Colors.red;
      case Level.fatal:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Debug'),
                  selected: _showDebug,
                  onSelected: (value) => setState(() => _showDebug = value),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: _showDebug ? Colors.white : Colors.blue,
                  ),
                ),
                FilterChip(
                  label: const Text('Info'),
                  selected: _showInfo,
                  onSelected: (value) => setState(() => _showInfo = value),
                  backgroundColor: Colors.green.withOpacity(0.2),
                  selectedColor: Colors.green,
                  labelStyle: TextStyle(
                    color: _showInfo ? Colors.white : Colors.green,
                  ),
                ),
                FilterChip(
                  label: const Text('Warning'),
                  selected: _showWarning,
                  onSelected: (value) => setState(() => _showWarning = value),
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(
                    color: _showWarning ? Colors.white : Colors.orange,
                  ),
                ),
                FilterChip(
                  label: const Text('Error'),
                  selected: _showError,
                  onSelected: (value) => setState(() => _showError = value),
                  backgroundColor: Colors.red.withOpacity(0.2),
                  selectedColor: Colors.red,
                  labelStyle: TextStyle(
                    color: _showError ? Colors.white : Colors.red,
                  ),
                ),
                FilterChip(
                  label: const Text('Fatal'),
                  selected: _showFatal,
                  onSelected: (value) => setState(() => _showFatal = value),
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  selectedColor: Colors.purple,
                  labelStyle: TextStyle(
                    color: _showFatal ? Colors.white : Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Log list
          Expanded(
            child: Builder(
              builder: (context) {
                final logs = AppLogger().logs.where((entry) {
                  if (entry.level == Level.debug && !_showDebug) return false;
                  if (entry.level == Level.info && !_showInfo) return false;
                  if (entry.level == Level.warning && !_showWarning) return false;
                  if (entry.level == Level.error && !_showError) return false;
                  if (entry.level == Level.fatal && !_showFatal) return false;
                  return true;
                }).toList();

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final entry = logs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      elevation: 1,
                      child: ListTile(
                        title: Text(
                          entry.message,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        subtitle: entry.error != null
                            ? Text(
                                '${entry.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        leading: Container(
                          width: 8,
                          height: 40,
                          color: _getLogColor(entry.level),
                        ),
                        trailing: Text(
                          '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}:${entry.timestamp.second.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Log Details (${entry.level.name.toUpperCase()})'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Time: ${entry.timestamp}'),
                                    const SizedBox(height: 8),
                                    const Text('Message:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SelectableText(entry.message),
                                    if (entry.error != null) ...[
                                      const SizedBox(height: 8),
                                      const Text('Error:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SelectableText(entry.error.toString()),
                                    ],
                                    if (entry.stackTrace != null) ...[
                                      const SizedBox(height: 8),
                                      const Text('Stack Trace:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SelectableText(entry.stackTrace.toString()),
                                    ],
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add some test logs
          AppLogger.d('This is a debug message');
          AppLogger.i('This is an info message');
          AppLogger.w('This is a warning message');
          AppLogger.e('This is an error message');
          setState(() {});
        },
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}
