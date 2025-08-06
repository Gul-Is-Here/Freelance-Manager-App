import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../data/models/project_model.dart';
import '../../../../data/services/database_service.dart';

class ProjectsController extends GetxController {
  final DatabaseService _databaseService = Get.find();
  var projects = <Project>[].obs;
  var project = Rxn<Project>(); // Observable for the current project
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

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

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
      print('Adding project: ${project.toMap()}');
      final db = await _databaseService.database;
      await db.insert('projects', project.toMap());
      await loadProjects();
      if (project.reminderEnabled) {
        await scheduleProjectReminder(project); // Schedule reminder if enabled
      }
      Get.snackbar('Success', 'Project added successfully');
    } catch (e) {
      print('Error adding project: $e');
      Get.snackbar('Error', 'Failed to add project: $e');
      throw e;
    }
  }

  Future<void> updateProject(Project updatedProject) async {
    try {
      print('Updating project: ${updatedProject.toMap()}');
      final db = await _databaseService.database;
      await db.update(
        'projects',
        updatedProject.toMap(),
        where: 'id = ?',
        whereArgs: [updatedProject.id],
      );
      if (project.value?.id == updatedProject.id) {
        project.value = updatedProject;
      }
      final index = projects.indexWhere((p) => p.id == updatedProject.id);
      if (index != -1) {
        projects[index] = updatedProject;
      }
      if (updatedProject.reminderEnabled) {
        await scheduleProjectReminder(updatedProject); // Update reminder
      } else {
        await cancelProjectReminder(updatedProject.id); // Cancel if disabled
      }
      Get.snackbar('Success', 'Project updated successfully');
    } catch (e) {
      print('Error updating project: $e');
      Get.snackbar('Error', 'Failed to update project: $e');
      throw e;
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final db = await _databaseService.database;
      await db.delete('projects', where: 'id = ?', whereArgs: [id]);
      if (project.value?.id == id) {
        project.value = null; // Clear the current project if deleted
      }
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
    setProject(project); // Set the current project
    Get.toNamed('/projects/detail', arguments: project);
  }

  void setProject(Project initialProject) {
    project.value = initialProject; // Initialize the observable project
  }
}
