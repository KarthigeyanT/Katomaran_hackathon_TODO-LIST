import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:katomaran_hackathon/theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  // Dummy tasks for demonstration (key: date, value: list of tasks)
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 5, 20): ['Team Meeting', 'Code Review'],
    DateTime(2025, 5, 26): ['Project Deadline', 'Client Call'],
    DateTime(2025, 6, 5): ['Design Review'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _addTask() {
    // Placeholder for adding a task
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add Task feature coming soon!'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventsForSelectedDay = _getEventsForDay(_selectedDay!);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Calendar',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Calendar Header with Navigation
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withAlpha((0.05 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: theme.colorScheme.primary),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                    });
                  },
                ),
                Text(
                  '${_focusedDay.month == 1 ? 'January' : _focusedDay.month == 2 ? 'February' : _focusedDay.month == 3 ? 'March' : _focusedDay.month == 4 ? 'April' : _focusedDay.month == 5 ? 'May' : _focusedDay.month == 6 ? 'June' : _focusedDay.month == 7 ? 'July' : _focusedDay.month == 8 ? 'August' : _focusedDay.month == 9 ? 'September' : _focusedDay.month == 10 ? 'October' : _focusedDay.month == 11 ? 'November' : 'December'} ${_focusedDay.year}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),
          // Calendar Grid
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
              headerVisible: false, // Custom header used above
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)) ?? TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                defaultTextStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface) ?? TextStyle(color: theme.colorScheme.onSurface),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tasks for Selected Day
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tasks for ${_selectedDay!.day} ${_selectedDay!.month == 1 ? 'January' : _selectedDay!.month == 2 ? 'February' : _selectedDay!.month == 3 ? 'March' : _selectedDay!.month == 4 ? 'April' : _selectedDay!.month == 5 ? 'May' : _selectedDay!.month == 6 ? 'June' : _selectedDay!.month == 7 ? 'July' : _selectedDay!.month == 8 ? 'August' : _selectedDay!.month == 9 ? 'September' : _selectedDay!.month == 10 ? 'October' : _selectedDay!.month == 11 ? 'November' : 'December'}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: eventsForSelectedDay.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: theme.colorScheme.onSurface.withAlpha((0.3 * 255).round()),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Tasks',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add a task for this day!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: eventsForSelectedDay.length,
                            itemBuilder: (context, index) {
                              final task = eventsForSelectedDay[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: theme.dividerColor, width: 1),
                                ),
                                color: theme.colorScheme.surface,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.task_alt,
                                    color: theme.colorScheme.primary,
                                    size: 24,
                                  ),
                                  title: Text(
                                    task,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: theme.colorScheme.primary,
        tooltip: 'Add new task',
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}