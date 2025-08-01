import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/modules/home/controllers/calculator_controller.dart';
import '../app/modules/home/controllers/earnings_controller.dart';
import '../app/modules/home/controllers/home_controller.dart';
import '../app/modules/home/controllers/projects_controller.dart';
import '../app/modules/home/controllers/settings_controller.dart';

class CustomNavBar extends StatelessWidget {
  final HomeController controller;
  const CustomNavBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectsController()); // Register controller here
    Get.put(CalculatorController()); // Register controller here
    Get.put(EarningsController()); // Register controller here
    Get.put(SettingsController()); // Register controller here
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
