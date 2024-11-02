// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = TaskProvider();
        provider.loadTasks(); // Chargement des tâches au démarrage
        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestionnaire de Tâches',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          fontFamily: 'Montserrat',
        ),
        home: const HomePage(),
      ),
    );
  }
}
