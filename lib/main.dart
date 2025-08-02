import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'app/modules/home/binding/app_binding.dart';
import 'app/modules/home/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/app_lock_middleware.dart';

// Database Helper for Theme Preferences
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialBinding = AppBinding();
  await initialBinding.dependencies();
  Get.put(ThemeController()); // Initialize ThemeController
  runApp(
    GetMaterialApp(
      routingCallback: (routing) {
        if (routing?.current == '/home') {
          Get.put(AppLockMiddleware());
        }
      },
      title: "Freelance Manager",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: await ThemeController().getThemeData('default'), // Default theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.teal[800]!,
          secondary: Colors.tealAccent[700]!,
          surface: Colors.grey[900]!,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal[800],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.tealAccent[700]!, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[300]),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
    ),
  );
}

// Theme Controller for managing theme preferences

// Example Theme Selection Widget (for settings page)
