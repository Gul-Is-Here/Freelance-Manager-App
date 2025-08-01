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
          CREATE TABLE projects(
            id TEXT PRIMARY KEY,
            title TEXT,
            clientName TEXT,
            isHourly INTEGER,
            hourlyRate REAL,
            fixedAmount REAL,
            estimatedHours REAL,
            deadline TEXT,
            notes TEXT,
            status TEXT,
            createdAt TEXT,
            reminderEnabled INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE calculations(
            id TEXT PRIMARY KEY,
            hourlyRate REAL,
            hours REAL,
            commission REAL,
            discount REAL,
            total REAL,
            netAmount REAL,
            createdAt TEXT
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
    return maps.map((map) => Project.fromMap(map)).toList();
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
        'Completed'
      ],
    );
    return maps.map((map) => Project.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}