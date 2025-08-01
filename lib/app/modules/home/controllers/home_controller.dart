import 'package:get/get.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/services/database_service.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var allProjects = <Project>[].obs;
  var ongoingProjects = <Project>[].obs;
  var completedProjects = <Project>[].obs;
  var totalEarnings = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      final db = await DatabaseService().database;
      final projects = await db.query('projects', orderBy: 'createdAt DESC');
      
      allProjects.assignAll(projects.map((p) => Project.fromMap(p)).toList());
      ongoingProjects.assignAll(allProjects.where((p) => p.status == 'Ongoing'));
      completedProjects.assignAll(allProjects.where((p) => p.status == 'Completed'));
      
      _calculateTotals();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    totalEarnings.value = completedProjects.fold(
        0.0, (sum, project) => sum + project.totalAmount);
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void navigateToAddProject() {
    Get.toNamed('/projects/form');
  }

  void navigateToProjectDetails(Project project) {
    Get.toNamed('/projects/detail', arguments: project);
  }
}