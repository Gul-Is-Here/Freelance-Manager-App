import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/projects_controller.dart';


class ProjectsView extends GetView<ProjectsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: controller.navigateToAddProject,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.projects.isEmpty) {
          return Center(
            child: Text(
              'No projects yet\nTap the + button to add one',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(project.title),
                subtitle: Text('${project.clientName} • ${project.status}'),
                trailing: Text(
                  '\$${project.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () => controller.navigateToProjectDetails(project),
              ),
            );
          },
        );
      }),
    );
  }
}