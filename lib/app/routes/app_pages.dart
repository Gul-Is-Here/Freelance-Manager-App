import 'package:frelance_calculator_app/app/modules/settings/screens/settings_view.dart';
import 'package:frelance_calculator_app/splash_screen.dart';
import 'package:get/get.dart';
import '../modules/calculator/bindings/calculator_binding.dart';
import '../modules/earnings/bindings/earnings_binding.dart';
import '../modules/home/home/bindings/home_binding.dart';
import '../modules/project/bindings/projects_binding.dart';
import '../modules/settings/bindings/settings_binding.dart';

import '../modules/calculator/screen/calculator_view.dart';
import '../modules/earnings/screens/earnings_view.dart';
import '../modules/home/home/screens/home_view.dart';
import '../modules/project/screens/project_detail_view.dart';
import '../modules/project/screens/project_form_view.dart';
import '../modules/project/screens/projects_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CALCULATOR,
      page: () => CalculatorView(),
      binding: CalculatorBinding(),
    ),
    GetPage(
      name: _Paths.PROJECTS,
      page: () => ProjectsView(),
      binding: ProjectsBinding(),
      children: [
        GetPage(
          name: _Paths.PROJECT_DETAIL,
          page: () => ProjectDetailView(project: Get.arguments),
        ),
        GetPage(
          name: _Paths.PROJECT_FORM,
          page: () => ProjectFormView(project: Get.arguments),
        ),
      ],
    ),
    GetPage(
      name: _Paths.EARNINGS,
      page: () => EarningsView(),
      binding: EarningsBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
