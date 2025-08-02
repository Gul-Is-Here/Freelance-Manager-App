import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../data/models/project_model.dart';

class DatabaseService extends GetxService {
  static Database? _database;

  DatabaseService() {
    tz.initializeTimeZones();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'freelance_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            clientName TEXT NOT NULL,
            isHourly INTEGER NOT NULL,
            hourlyRate REAL NOT NULL,
            fixedAmount REAL NOT NULL,
            estimatedHours REAL NOT NULL,
            deadline TEXT NOT NULL,
            notes TEXT NOT NULL,
            status TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            reminderEnabled INTEGER NOT NULL,
            logoBytes BLOB,
            companyName TEXT,
            companyAddress TEXT,
            companyEmail TEXT,
            companyPhone TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE calculations(
            id TEXT PRIMARY KEY,
            hourlyRate REAL NOT NULL,
            hours REAL NOT NULL,
            commission REAL NOT NULL,
            discount REAL NOT NULL,
            total REAL NOT NULL,
            netAmount REAL NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Project>> getCompletedProjects() async {
    final db = await database;
    final maps = await db.query(
      'projects',
      where: 'status = ?',
      whereArgs: ['Completed'],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Project.fromMap(maps[i]));
  }

  Future<List<Project>> getProjectsByMonth(DateTime month) async {
    final db = await database;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final maps = await db.query(
      'projects',
      where: 'createdAt BETWEEN ? AND ? AND status = ?',
      whereArgs: [
        firstDay.toIso8601String(),
        lastDay.toIso8601String(),
        'Completed',
      ],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Project.fromMap(maps[i]));
  }

  Future<int> insertProject(Project project) async {
    final db = await database;
    return await db.insert(
      'projects',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProject(Project project) async {
    final db = await database;
    return await db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> deleteProject(String id) async {
    final db = await database;
    return await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  Future<Project?> getProjectById(String id) async {
    final db = await database;
    final maps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Project.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Project>> getAllProjects() async {
    final db = await database;
    final maps = await db.query('projects', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) => Project.fromMap(maps[i]));
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
