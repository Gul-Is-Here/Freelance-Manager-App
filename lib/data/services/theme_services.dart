import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ThemeDatabase {
  static final ThemeDatabase instance = ThemeDatabase._init();
  static Database? _database;

  ThemeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('theme.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE theme (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      themeName TEXT,
      primaryColor INTEGER,
      secondaryColor INTEGER
    )
    ''');
  }

  Future<void> saveTheme(String themeName, {int? primaryColor, int? secondaryColor}) async {
    final db = await database;
    await db.delete('theme'); // Clear previous theme
    await db.insert('theme', {
      'themeName': themeName,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    });
  }

  Future<Map<String, dynamic>?> getTheme() async {
    final db = await database;
    final result = await db.query('theme', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }
}