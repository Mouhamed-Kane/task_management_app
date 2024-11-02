// lib/screens/completed_tasks_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_task_page.dart';
import 'home_page.dart';
import 'tasks_in_progress_page.dart';
import 'calendar_page.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tâches terminées'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasks;
          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'En cours'),
          BottomNavigationBarItem(icon: Icon(Icons.done_all), label: 'Terminées'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendrier'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TasksInProgressPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
