part of 'app_pages.dart';

abstract class Routes {
  Routes._();
    static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const PROJECTS = _Paths.PROJECTS;
  static const PROJECT_DETAIL = _Paths.PROJECT_DETAIL;
  static const PROJECT_FORM = _Paths.PROJECT_FORM;
  static const CALCULATOR = _Paths.CALCULATOR;
  static const EARNINGS = _Paths.EARNINGS;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
   static const SPLASH = '/splash';
  static const HOME = '/home';
  static const PROJECTS = '/projects';
  static const PROJECT_DETAIL = '/detail';
  static const PROJECT_FORM = '/form';
  static const CALCULATOR = '/calculator';
  static const EARNINGS = '/earnings';
  static const SETTINGS = '/settings';
}