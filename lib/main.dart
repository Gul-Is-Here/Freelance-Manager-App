import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/modules/home/binding/app_binding.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_lock_middleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialBinding = AppBinding();
  await initialBinding.dependencies();
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
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.blue[800]!,
          secondary: Colors.blueAccent[700]!,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue[800],
        ),
      ),
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
    ),
  );
}
