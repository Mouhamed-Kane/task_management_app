// lib/screens/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'home_page.dart';
import 'tasks_in_progress_page.dart';
import 'completed_tasks_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            // Style du calendrier
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final tasksForSelectedDay = taskProvider.allTasks
                    .where((task) =>
                        task.dueDate != null &&
                        isSameDay(task.dueDate!, _selectedDay ?? _focusedDay))
                    .toList();

                return ListView.builder(
                  itemCount: tasksForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final task = tasksForSelectedDay[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description ?? ''),
                      trailing: Icon(
                        Icons.circle,
                        color: task.priority == 'élevé'
                            ? Colors.red
                            : task.priority == 'moyen'
                                ? Colors.orange
                                : Colors.green,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
        currentIndex: 3, // Index pour la page calendrier
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
                MaterialPageRoute(
                    builder: (context) => const TasksInProgressPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CompletedTasksPage()),
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
