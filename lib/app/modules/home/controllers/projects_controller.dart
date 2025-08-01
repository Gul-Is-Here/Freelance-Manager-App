import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;


import '../../../../data/models/project_model.dart';
import '../../../../data/services/database_service.dart';

class ProjectsController extends GetxController {
  final DatabaseService _databaseService = Get.find();
  var projects = <Project>[].obs;
  var isLoading = false.obs;
final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();
  @override
  void onInit() {
    super.onInit();
    loadProjects();
      _initializeNotifications();
  }
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  
  await _notificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleProjectReminder(Project project) async {
  if (project.reminderEnabled && project.deadline.isAfter(DateTime.now())) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'project_reminders',
      'Project Reminders',
      channelDescription: 'Notifications for project deadlines',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _notificationsPlugin.zonedSchedule(
  project.id.hashCode,
  'Project Deadline: ${project.title}',
  'Due on ${project.formattedDeadline}',
  tz.TZDateTime.from(
    project.deadline.subtract(Duration(hours: 24)),
    tz.local,
  ),
  platformChannelSpecifics,
  
  androidScheduleMode: AndroidScheduleMode.exact,
);
  }
}

Future<void> cancelProjectReminder(String projectId) async {
  await _notificationsPlugin.cancel(projectId.hashCode);
}
  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      final db = await _databaseService.database;
      final maps = await db.query('projects', orderBy: 'deadline ASC');
      projects.assignAll(maps.map((map) => Project.fromMap(map)).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProject(Project project) async {
    try {
      final db = await _databaseService.database;
      await db.insert('projects', project.toMap());
      await loadProjects();
      Get.snackbar('Success', 'Project added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add project: $e');
      throw e;
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'projects',
        project.toMap(),
        where: 'id = ?',
        whereArgs: [project.id],
      );
      await loadProjects();
      Get.snackbar('Success', 'Project updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update project: $e');
      throw e;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'projects',
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadProjects();
      Get.snackbar('Success', 'Project deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete project: $e');
      throw e;
    }
  }

  void navigateToAddProject() {
    Get.toNamed('/projects/form');
  }

  void navigateToProjectDetails(Project project) {
    Get.toNamed('/projects/detail', arguments: project);
  }
}