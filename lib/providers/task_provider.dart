// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/local_storage/task_storage_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskStorageService _storage = TaskStorageService();
  List<Task> _tasks = [];
  List<Task> get allTasks => _tasks;
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    final tasksData = await _storage.loadTasks();
    _tasks = tasksData.map((json) => Task.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await _storage.saveTasks(tasksJson);
  }
}
