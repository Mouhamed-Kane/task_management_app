// lib/services/local_storage/task_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class TaskStorageService {
  static const String _tasksKey = 'tasks';
  
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = jsonEncode(tasks);
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<List<Map<String, dynamic>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null) return [];
    
    List<dynamic> decoded = jsonDecode(tasksJson);
    return decoded.cast<Map<String, dynamic>>();
  }
}
