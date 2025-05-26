import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:katomaran_hackathon/providers/task_provider.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';
import 'package:katomaran_hackathon/models/task.dart';
import 'package:katomaran_hackathon/screens/task_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final tasks = taskProvider.tasks;
          final completedTasks = tasks.where((t) => t.isCompleted).length;
          final pendingTasks = tasks.length - completedTasks;
          final progress = tasks.isNotEmpty ? (completedTasks / tasks.length) * 100 : 0;
          
          // Get tasks due today
          final today = DateTime.now();
          final todayTasks = tasks.where((task) => 
            task.dueDate.year == today.year &&
            task.dueDate.month == today.month &&
            task.dueDate.day == today.day
          ).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Dashboard'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Card
                      _buildStatCard(
                        context,
                        'Your Progress',
                        '$completedTasks/${tasks.length} tasks completed',
                        Icons.assessment_outlined,
                        '${progress.toStringAsFixed(0)}%',
                        LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Today\'s Tasks',
                              '${todayTasks.length} tasks',
                              Icons.today_outlined,
                              '',
                              null,
                              color: Colors.blue[100],
                              iconColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              'Pending',
                              '$pendingTasks tasks',
                              Icons.pending_actions_outlined,
                              '',
                              null,
                              color: Colors.orange[100],
                              iconColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Recent Tasks
                      if (todayTasks.isNotEmpty) ...[
                        Text(
                          'Due Today',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...todayTasks.map((task) => _buildTaskItem(context, task)).toList(),
                      ] else ...[
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.celebration_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks due today!',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String trailing,
    Widget? progress, {
    Color? color,
    Color? iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color ?? AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                if (trailing.isNotEmpty)
                  Text(
                    trailing,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 12),
              progress,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            final updatedTask = Task(
              id: task.id,
              title: task.title,
              description: task.description,
              dueDate: task.dueDate,
              isCompleted: value ?? false,
            );
            Provider.of<TaskProvider>(context, listen: false)
                .updateTask(updatedTask);
          },
          activeColor: AppTheme.primaryColor,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description.isNotEmpty ? task.description : 'No description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Text(
          '${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => TaskFormScreen(taskToEdit: task),
          );
        },
      ),
    );
  }
}
