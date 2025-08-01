import 'package:frelance_calculator_app/app/modules/home/view/settings_view.dart';
import 'package:get/get.dart';
import '../modules/home/binding/calculator_binding.dart';
import '../modules/home/binding/earnings_binding.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/binding/projects_binding.dart';
import '../modules/home/binding/settings_binding.dart';

import '../modules/home/view/calculator_view.dart';
import '../modules/home/view/earnings_view.dart';
import '../modules/home/view/home_view.dart';
import '../modules/home/view/project/project_detail_view.dart';
import '../modules/home/view/project/project_form_view.dart';
import '../modules/home/view/project/projects_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
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
