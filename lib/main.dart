import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'app/app_binding.dart';
import 'app/modules/home/home/controller/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/app_lock_middleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialBinding = AppBinding();
  await initialBinding.dependencies();

  final themeController = Get.put(ThemeController());
  final defaultTheme = await themeController.getThemeData(
    'default',
  ); // ✅ Await here

  runApp(MyApp(defaultTheme: defaultTheme));
}

class MyApp extends StatelessWidget {
  final ThemeData defaultTheme;

  const MyApp({super.key, required this.defaultTheme}); // ✅ Accept theme

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routingCallback: (routing) {
        if (routing?.current == '/home') {
          Get.put(AppLockMiddleware());
        }
      },
      title: "Freelance Manager",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme, // ✅ Set theme here
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 21, 22, 22),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 44, 46, 45),
          secondary: Color(0xFF00FFA3),
          surface: Color(0xFF121212),
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 29, 30, 30),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 46, 48, 48),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 42, 45, 44),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[300]),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
    );
  }
}
