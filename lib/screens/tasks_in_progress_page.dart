// lib/screens/tasks_in_progress_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_task_page.dart';
import 'home_page.dart';
import 'completed_tasks_page.dart';
import 'calendar_page.dart';

class TasksInProgressPage extends StatelessWidget {
  const TasksInProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tâches en cours'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Filtrer les tâches non terminées
          final incompleteTasks = taskProvider.tasks.where((task) => !task.isCompleted).toList();
          
          return ListView.builder(
            itemCount: incompleteTasks.length,
            itemBuilder: (context, index) {
              final task = incompleteTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // Mettre à jour le statut de la tâche
                    final updatedTask = Task(
                      id: task.id,
                      title: task.title,
                      description: task.description,
                      dueDate: task.dueDate,
                      priority: task.priority,
                      isCompleted: true,
                    );
                    taskProvider.updateTask(updatedTask);
                  },
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
        currentIndex: 1,
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
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CompletedTasksPage()),
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
