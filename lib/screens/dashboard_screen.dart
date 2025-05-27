import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:katomaran_hackathon/providers/task_provider.dart';
import 'package:katomaran_hackathon/models/task.dart';
import 'package:katomaran_hackathon/screens/task_form_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'All';
  final List<String> _categories = ['All', 'Personal', 'Work', 'Shopping', 'Others'];

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _selectedFilter == 'All'
        ? taskProvider.tasks
        : taskProvider.tasks.where((t) => t.list == _selectedFilter).toList();

    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;
    final progress = tasks.isNotEmpty ? (completedTasks / tasks.length) * 100 : 0;

    final today = DateTime.now();
    final todayTasks = tasks.where((t) => _isSameDay(t.dueDate, today)).toList();
    final overdueTasks = tasks.where((t) => !t.isCompleted && t.dueDate.isBefore(today)).toList();
    final upcomingTasks = tasks
        .where((t) =>
            !t.isCompleted && t.dueDate.isAfter(today) && t.dueDate.isBefore(today.add(const Duration(days: 3))))
        .toList();

    // Calculate dynamic crossAxisCount based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 180).floor().clamp(2, 4); // Minimum 2, max 4 columns
    final childAspectRatio = screenWidth < 600 ? 1.4 : 1.6; // Adjust aspect ratio for larger screens

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 64,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 12),
              title: Text(
                'Dashboard',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedFilter == category,
                        onSelected: (selected) =>
                            setState(() => _selectedFilter = selected ? category : 'All'),
                        labelStyle: TextStyle(
                          color: _selectedFilter == category ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.7),
                        ),
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Bento Cards
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              delegate: SliverChildListDelegate([
                _buildBentoCard(
                  title: 'Progress',
                  value: '${progress.toStringAsFixed(0)}%',
                  subtitle: '$completedTasks/${tasks.length} tasks',
                  icon: Icons.trending_up,
                  color: colorScheme.primary,
                  progress: progress / 100,
                  theme: theme,
                  screenWidth: screenWidth,
                ),
                _buildBentoCard(
                  title: 'Today',
                  value: '${todayTasks.length}',
                  subtitle: 'Tasks due',
                  icon: Icons.today,
                  color: Colors.blueAccent,
                  theme: theme,
                  screenWidth: screenWidth,
                ),
                _buildBentoCard(
                  title: 'Pending',
                  value: '$pendingTasks',
                  subtitle: 'Tasks waiting',
                  icon: Icons.pending_actions,
                  color: Colors.orangeAccent,
                  theme: theme,
                  screenWidth: screenWidth,
                ),
                _buildBentoCard(
                  title: 'Overdue',
                  value: '${overdueTasks.length}',
                  subtitle: 'Tasks late',
                  icon: Icons.warning,
                  color: Colors.redAccent,
                  theme: theme,
                  screenWidth: screenWidth,
                ),
              ]),
            ),
          ),

          // Upcoming Tasks Header
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    'Upcoming Tasks',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${upcomingTasks.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Task List
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 80),
            sliver: upcomingTasks.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.celebration_rounded, size: 64, color: colorScheme.onSurface.withOpacity(0.1)),
                            const SizedBox(height: 16),
                            Text(
                              'No upcoming tasks',
                              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildTaskItem(upcomingTasks[index], theme, colorScheme),
                      childCount: upcomingTasks.length,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const TaskFormScreen(),
          );
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    required double screenWidth,
    double? progress,
  }) {
    final colorScheme = theme.colorScheme;
    // Dynamic font sizes and padding based on screen width
    final titleFontSize = screenWidth < 600 ? 14.0 : 16.0;
    final valueFontSize = screenWidth < 600 ? 20.0 : 24.0;
    final subtitleFontSize = screenWidth < 600 ? 12.0 : 14.0;
    final iconSize = screenWidth < 600 ? 18.0 : 20.0;
    final padding = screenWidth < 600 ? 12.0 : 16.0;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
        ),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure even spacing
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(padding / 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: titleFontSize,
                  ),
                ),
                SizedBox(height: padding / 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: subtitleFontSize,
                  ),
                ),
                if (progress != null) ...[
                  SizedBox(height: padding / 2),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => TaskFormScreen(taskToEdit: task),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: task.isCompleted ? colorScheme.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? colorScheme.primary : colorScheme.outline.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        task.isCompleted = !task.isCompleted;
                        Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                      });
                    },
                    child: task.isCompleted
                        ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                        : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? colorScheme.onSurface.withOpacity(0.5)
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: colorScheme.onSurface.withOpacity(0.4)),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(task.dueDate),
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getListColor(task.list, colorScheme).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              task.list,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getListColor(task.list, colorScheme),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getListColor(String list, ColorScheme colorScheme) {
    switch (list) {
      case 'Personal':
        return const Color(0xFF00BFA5);
      case 'Work':
        return const Color(0xFF2962FF);
      case 'Shopping':
        return const Color(0xFFF57C00);
      case 'Others':
        return const Color(0xFF9C27B0);
      default:
        return colorScheme.primary;
    }
  }
}