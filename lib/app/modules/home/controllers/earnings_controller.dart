import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../data/models/project_model.dart';
import '../../../../data/services/database_service.dart';

class EarningsController extends GetxController {
  var completedProjects = <Project>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var selectedMonth = DateTime.now().obs;
  var totalEarnings = 0.0.obs;
  var totalHours = 0.0.obs;
  var monthlyEarningsData = <Map<String, dynamic>>[].obs;
  final DatabaseService _databaseService = Get.find();
  @override
  void onInit() {
    super.onInit();
    loadCompletedProjects();
  }

  Future<void> loadCompletedProjects() async {
    try {
      isLoading.value = true;
      final projects = await _databaseService.getCompletedProjects();
      completedProjects.assignAll(projects);
      _calculateTotals();
      _generateMonthlyEarningsData();
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void _filterProjectsByMonth() {
    loadProjectsByMonth(selectedMonth.value);
  }

  Future<void> loadProjectsByMonth(DateTime month) async {
    try {
      isLoading.value = true;
      final projects = await _databaseService.getProjectsByMonth(month);
      completedProjects.assignAll(projects);
      _calculateTotals();
      _generateMonthlyEarningsData();
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    totalEarnings.value = completedProjects.fold(
      0.0,
      (sum, project) => sum + project.totalAmount,
    );
    totalHours.value = completedProjects.fold(
      0.0,
      (sum, project) => sum + project.estimatedHours,
    );
  }

  void _generateMonthlyEarningsData() {
    final formatter = DateFormat('MMM yyyy');
    final Map<String, double> monthlyEarnings = {};

    for (final project in completedProjects) {
      final monthKey = formatter.format(project.createdAt);
      monthlyEarnings[monthKey] =
          (monthlyEarnings[monthKey] ?? 0) + project.totalAmount;
    }

    monthlyEarningsData.assignAll(
      monthlyEarnings.entries
          .map((entry) => {'month': entry.key, 'earnings': entry.value})
          .toList(),
    );
  }

  void changeMonth(bool next) {
    final month = next ? 1 : -1;
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + month,
      1,
    );
    _filterProjectsByMonth();
  }
}
