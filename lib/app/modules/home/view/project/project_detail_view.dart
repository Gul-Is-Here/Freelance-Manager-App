import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/models/project_model.dart';
import '../../../../../data/services/invoice_service.dart';

class ProjectDetailView extends StatelessWidget {
  final Project project;

  const ProjectDetailView({required this.project, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Get.toNamed(
              '/projects/form',
              arguments: project,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Client: ${project.clientName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(height: 32),
            _buildDetailRow('Type', project.isHourly ? 'Hourly' : 'Fixed Price'),
            _buildDetailRow(
              project.isHourly ? 'Hourly Rate' : 'Fixed Amount',
              '\$${project.isHourly ? project.hourlyRate.toStringAsFixed(2) : project.fixedAmount.toStringAsFixed(2)}',
            ),
            if (project.isHourly)
              _buildDetailRow(
                'Estimated Hours',
                project.estimatedHours.toStringAsFixed(1),
              ),
            _buildDetailRow(
              'Total Amount',
              '\$${project.totalAmount.toStringAsFixed(2)}',
              isAmount: true,
            ),
            _buildDetailRow('Status', project.status),
            _buildDetailRow('Deadline', project.formattedDeadline),
            _buildDetailRow('Created', project.formattedCreatedAt),
            Divider(height: 32),
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(
              project.notes.isEmpty ? 'No notes' : project.notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            ElevatedButton.icon(
  icon: Icon(Icons.receipt),
  label: Text('Generate Invoice'),
  onPressed: () => Get.find<InvoiceService>().generateAndPrintInvoice(project),
),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: isAmount
                ? TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(Get.context!).primaryColor,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}