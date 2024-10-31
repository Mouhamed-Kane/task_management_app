// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get allTasks => _tasks;
  List<Task> get incompleteTasks =>
      _tasks.where((task) => !task.isCompleted).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskStatus(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
