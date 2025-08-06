import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<void> saveTheme(
    String themeName, {
    int? primaryColor,
    int? secondaryColor,
  }) async {
    final db = await database;
    await db.delete('theme');
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

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  final ThemeDatabase _themeDatabase = ThemeDatabase.instance;
  var currentTheme = 'default'.obs;
  var currentThemeData = ThemeData.light().obs; // Cache current ThemeData

  @override
  void onInit() async {
    super.onInit();
    final savedTheme = await _themeDatabase.getTheme();
    if (savedTheme != null) {
      currentTheme.value = savedTheme['themeName'] as String;
      currentThemeData.value = await getThemeData(currentTheme.value);
    } else {
      currentThemeData.value = await getThemeData('default');
    }
  }

  void switchTheme(String theme) async {
    currentTheme.value = theme;
    currentThemeData.value = await getThemeData(theme);
    await _themeDatabase.saveTheme(theme);
    Get.changeTheme(currentThemeData.value);
  }

  void setCustomTheme(Color primary, Color secondary) async {
    currentTheme.value = 'custom';
    await _themeDatabase.saveTheme(
      'custom',
      primaryColor: primary.value,
      secondaryColor: secondary.value,
    );
    currentThemeData.value = await getThemeData('custom');
    Get.changeTheme(currentThemeData.value);
  }

  Future<ThemeData> getThemeData(String theme) async {
    final savedTheme = await _themeDatabase.getTheme();
    switch (theme) {
      case 'pink':
        return ThemeData.light().copyWith(
          primaryColor: Colors.pink,
          colorScheme: ColorScheme.light(
            primary: Colors.pink,
            secondary: Colors.pinkAccent,
            surface: Colors.pink[50]!,
          ),
          scaffoldBackgroundColor: Colors.pink[50],
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.pink,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.pink[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.grey[800]),
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        );
      case 'custom':
        final primary = savedTheme != null && savedTheme['primaryColor'] != null
            ? Color(savedTheme['primaryColor'] as int)
            : Colors.blue;
        final secondary =
            savedTheme != null && savedTheme['secondaryColor'] != null
            ? Color(savedTheme['secondaryColor'] as int)
            : Colors.blueAccent;
        return ThemeData.light().copyWith(
          primaryColor: primary,
          colorScheme: ColorScheme.light(
            primary: primary,
            secondary: secondary,
            surface: primary.withOpacity(0.05),
          ),
          scaffoldBackgroundColor: primary.withOpacity(0.05),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: primary,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: primary.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: secondary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.grey[800]),
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        );
      default:
        return ThemeData.light().copyWith(
          primaryColor: Colors.redAccent,
          colorScheme: ColorScheme.light(
            primary: Colors.redAccent,
            secondary: Colors.redAccent,
            // surface: Colors.redAccent[50]!,
          ),
          scaffoldBackgroundColor: Colors.teal[50],
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.redAccent,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.teal[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.grey[800]),
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        );
    }
  }
}
