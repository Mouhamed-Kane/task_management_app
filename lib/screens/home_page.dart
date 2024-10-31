// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
// import '../models/task.dart';
import 'add_task_page.dart';
import 'tasks_in_progress_page.dart';
import 'completed_tasks_page.dart';
import 'calendar_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        centerTitle: true,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.allTasks;
          if (tasks.isEmpty) {
            return const Center(
              child: Text('Aucune tâche pour le moment'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: task.isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          taskProvider.toggleTaskStatus(task.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          taskProvider.deleteTask(task.id);
                        },
                      ),
                    ],
                  ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'En cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Terminées',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendrier',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TasksInProgressPage()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompletedTasksPage()));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarPage()));
              break;
          }
        },
      ),
    );
  }
}
