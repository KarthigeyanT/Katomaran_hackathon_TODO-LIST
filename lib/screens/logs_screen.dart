import 'package:flutter/material.dart';
import 'package:katomaran_hackathon/utils/logger_util.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = AppLogger().logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        centerTitle: true,
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No logs available'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text(log.message),
                  subtitle: Text(log.timestamp.toIso8601String()),
                );
              },
            ),
    );
  }
}
