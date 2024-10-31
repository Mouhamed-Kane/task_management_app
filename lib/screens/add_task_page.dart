// lib/screens/add_task_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _priority = 'faible';

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Créer une nouvelle tâche
      final task = Task(
        id: DateTime.now()
            .toString(), // Utilisation d'un ID simple pour l'exemple
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate,
        priority: _priority,
      );

      // Ajouter la tâche via le Provider
      Provider.of<TaskProvider>(context, listen: false).addTask(task);

      // Retourner à la page précédente
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle tâche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date d\'échéance'),
                subtitle: Text(_selectedDate == null
                    ? 'Aucune date sélectionnée'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priorité',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'faible', child: Text('Faible')),
                  DropdownMenuItem(value: 'moyen', child: Text('Moyen')),
                  DropdownMenuItem(value: 'élevé', child: Text('Élevé')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Ajouter la tâche'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
