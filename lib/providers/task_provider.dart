import 'package:flutter/foundation.dart';
import 'package:katomaran_hackathon/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  
  List<Task> get tasks => List.unmodifiable(_tasks);
  
  // In-memory session-only CRUD
  TaskProvider();

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = Task(
        id: _tasks[index].id,
        title: _tasks[index].title,
        description: _tasks[index].description,
        dueDate: _tasks[index].dueDate,
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }
}
