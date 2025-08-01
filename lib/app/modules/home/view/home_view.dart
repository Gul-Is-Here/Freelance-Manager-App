import 'package:flutter/material.dart';
import 'package:frelance_calculator_app/app/modules/home/view/calculator_view.dart';
import 'package:frelance_calculator_app/app/modules/home/view/earnings_view.dart';
import 'package:frelance_calculator_app/app/modules/home/view/project/projects_view.dart';
import 'package:frelance_calculator_app/app/modules/home/view/settings_view.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/bottom_nav_bar.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freelance Manager'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.loadProjects(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        switch (controller.currentIndex.value) {
          case 0:
            return _buildHomeDashboard();
          case 1:
            return ProjectsView();
          case 2:
            return CalculatorView();
          case 3:
            return EarningsView();
          case 4:
            return SettingsView();
          default:
            return Center(child: Text("Page not found"));
        }
      }),
      bottomNavigationBar: CustomNavBar(controller: controller),
    );
  }

  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(),
          SizedBox(height: 20),
          _buildRecentProjects(),
          SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Ongoing',
            controller.ongoingProjects.length.toString(),
            Colors.blue,
            Icons.work,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Completed',
            controller.completedProjects.length.toString(),
            Colors.green,
            Icons.check_circle,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Earnings',
            '\$${controller.totalEarnings.value.toStringAsFixed(2)}',
            Colors.orange,
            Icons.attach_money,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Projects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (controller.allProjects.isEmpty)
          Center(
            child: Text(
              'No projects yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...controller.allProjects
              .take(3)
              .map(
                (project) => Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      project.status == 'Completed'
                          ? Icons.check_circle
                          : Icons.work,
                      color: project.status == 'Completed'
                          ? Colors.green
                          : Colors.blue,
                    ),
                    title: Text(project.title),
                    subtitle: Text('${project.clientName} • ${project.status}'),
                    trailing: Text(
                      '\$${project.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () => controller.navigateToProjectDetails(project),
                  ),
                ),
              ),
        if (controller.allProjects.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => controller.changePage(1), // Navigate to Projects
              child: Text('View All'),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'Add Project',
                Icons.add,
                Colors.blue,
                () => controller.navigateToAddProject(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionButton(
                'Calculate',
                Icons.calculate,
                Colors.orange,
                () => controller.changePage(2), // Navigate to Calculator
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color.withOpacity(0.1),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
    );
  }
}
