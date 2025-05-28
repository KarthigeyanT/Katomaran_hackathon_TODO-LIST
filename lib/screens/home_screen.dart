import 'package:flutter/material.dart';
import 'package:katomaran_hackathon/screens/task_form_screen.dart';
import 'package:katomaran_hackathon/models/task.dart';
import 'package:katomaran_hackathon/providers/task_provider.dart';
import 'package:katomaran_hackathon/screens/logs_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  String _searchQuery = '';
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showAddTaskModal() {
    _fabAnimationController.forward(from: 0.0);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskFormScreen(),
    );
  }

  Future<void> _refreshTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  List<Task> _filterTasks(List<Task> tasks) {
    List<Task> result = tasks;
    if (_tabIndex == 1) {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (_tabIndex == 2) {
      result = result.where((t) => t.isCompleted).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _filterTasks(taskProvider.tasks);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 16,
        toolbarHeight: 48,
        title: Text(
          'My Tasks',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LogsScreen(),
                ),
              );
            },
            tooltip: 'View Logs',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withAlpha((0.05 * 255).round()),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
              ),
              labelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Open'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTasks,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withAlpha((0.1 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: tasks.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task_alt_outlined, size: 80, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text(
                              'No Tasks Found',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to add a task!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              taskProvider.deleteTask(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task "${task.title}" deleted'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: theme.dividerColor),
                              ),
                              color: theme.colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Checkbox(
                                        value: task.isCompleted,
                                        onChanged: (_) => taskProvider.toggleTaskCompletion(task.id),
                                        activeColor: theme.colorScheme.primary,
                                        checkColor: theme.colorScheme.onPrimary,
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  task.title,
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.edit, color: theme.iconTheme.color?.withAlpha((0.6 * 255).round())), 
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TaskFormScreen(taskToEdit: task),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                          if (task.description.isNotEmpty)
                                            Text(
                                              task.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${task.dueDate.year}/${task.dueDate.month.toString().padLeft(2, '0')}/${task.dueDate.day.toString().padLeft(2, '0')}',
                                                style: theme.textTheme.bodySmall,
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(Icons.access_time, size: 16, color: theme.colorScheme.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${task.dueDate.hour.toString().padLeft(2, '0')}:${task.dueDate.minute.toString().padLeft(2, '0')}',
                                                style: theme.textTheme.bodySmall,
                                              ),
                                              const SizedBox(width: 12),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.primary.withAlpha((0.08 * 255).round()),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  task.list,
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: tasks.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: _showAddTaskModal,
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
