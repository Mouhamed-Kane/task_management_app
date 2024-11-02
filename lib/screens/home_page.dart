// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
// import '../models/task.dart';
import 'add_task_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'completed_tasks_page.dart';
import 'tasks_in_progress_page.dart';
import 'calendar_page.dart';

// Ajoutez ces enum en haut du fichier
enum TaskFilter { all, active, completed }

enum SortBy { priority, dueDate, title }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskFilter _currentFilter = TaskFilter.all;
  SortBy _currentSort = SortBy.dueDate;
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TasksInProgressPage(),
    CompletedTasksPage(),
    CalendarPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (TaskFilter filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskFilter>>[
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.all,
                child: Text('Toutes'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.active,
                child: Text('À faire'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.completed,
                child: Text('Terminées'),
              ),
            ],
          ),
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            onSelected: (SortBy sort) {
              setState(() {
                _currentSort = sort;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.priority,
                child: Text('Par priorité'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.dueDate,
                child: Text('Par date'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.title,
                child: Text('Par titre'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('A Propos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Aide'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Réglages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          var tasks = taskProvider.tasks;

          // Filtrage
          tasks = tasks.where((task) {
            switch (_currentFilter) {
              case TaskFilter.active:
                return !task.isCompleted;
              case TaskFilter.completed:
                return task.isCompleted;
              default:
                return true;
            }
          }).toList();

          // Tri
          tasks.sort((a, b) {
            switch (_currentSort) {
              case SortBy.priority:
                return _priorityValue(a.priority)
                    .compareTo(_priorityValue(b.priority));
              case SortBy.dueDate:
                if (a.dueDate == null) return 1;
                if (b.dueDate == null) return -1;
                return a.dueDate!.compareTo(b.dueDate!);
              case SortBy.title:
                return a.title.compareTo(b.title);
            }
          });

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
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .updateTask(task.copyWith(isCompleted: value));
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
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), label: 'Terminées'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendrier'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  int _priorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'élevé':
        return 0;
      case 'moyen':
        return 1;
      default:
        return 2;
    }
  }
}
