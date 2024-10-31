// lib/models/task.dart
class Task {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 'faible',
    this.isCompleted = false,
  });
}
