// // lib/utils/database_helper.dart
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/task.dart';

// class DatabaseHelper {
//   static Database? _database;
  
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDB();
//     return _database!;
//   }

//   Future<Database> initDB() async {
//     String path = join(await getDatabasesPath(), 'tasks.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE tasks(
//             id TEXT PRIMARY KEY,
//             title TEXT NOT NULL,
//             description TEXT,
//             dueDate TEXT,
//             priority TEXT NOT NULL,
//             isCompleted INTEGER NOT NULL
//           )
//         ''');
//       }
//     );
//   }

//   Future<void> insertTask(Task task) async {
//     final Database db = await database;
//     await db.insert(
//       'tasks',
//       {
//         'id': task.id,
//         'title': task.title,
//         'description': task.description,
//         'dueDate': task.dueDate?.toIso8601String(),
//         'priority': task.priority,
//         'isCompleted': task.isCompleted ? 1 : 0,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<Task>> getTasks() async {
//     final Database db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('tasks');
    
//     return maps.map((map) => Task(
//       id: map['id'],
//       title: map['title'],
//       description: map['description'],
//       dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
//       priority: map['priority'],
//       isCompleted: map['isCompleted'] == 1,
//     )).toList();
//   }

//   Future<void> updateTask(Task task) async {
//     final Database db = await database;
//     await db.update(
//       'tasks',
//       {
//         'title': task.title,
//         'description': task.description,
//         'dueDate': task.dueDate?.toIso8601String(),
//         'priority': task.priority,
//         'isCompleted': task.isCompleted ? 1 : 0,
//       },
//       where: 'id = ?',
//       whereArgs: [task.id],
//     );
//   }

//   Future<void> deleteTask(String id) async {
//     final Database db = await database;
//     await db.delete(
//       'tasks',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
