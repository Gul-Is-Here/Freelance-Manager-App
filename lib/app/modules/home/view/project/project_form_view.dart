import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/project_model.dart';
import '../../controllers/projects_controller.dart';

class ProjectFormView extends StatefulWidget {
  final Project? project;

  const ProjectFormView({this.project, Key? key}) : super(key: key);

  @override
  _ProjectFormViewState createState() => _ProjectFormViewState();
}

class _ProjectFormViewState extends State<ProjectFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _clientController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _fixedAmountController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  final _notesController = TextEditingController();
  final _isHourly = true.obs;
  final _status = 'Ongoing'.obs;
  final _deadline = DateTime.now().add(Duration(days: 7)).obs;

  ProjectsController get controller => Get.find();

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleController.text = widget.project!.title;
      _clientController.text = widget.project!.clientName;
      _isHourly.value = widget.project!.isHourly;
      _hourlyRateController.text = widget.project!.hourlyRate.toString();
      _fixedAmountController.text = widget.project!.fixedAmount.toString();
      _estimatedHoursController.text = widget.project!.estimatedHours
          .toString();
      _notesController.text = widget.project!.notes;
      _status.value = widget.project!.status;
      _deadline.value = widget.project!.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _clientController.dispose();
    _hourlyRateController.dispose();
    _fixedAmountController.dispose();
    _estimatedHoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deadline.value) {
      setState(() {
        _deadline.value = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
        actions: [
          if (widget.project != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteProject(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Project Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _clientController,
                decoration: InputDecoration(labelText: 'Client Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter client name' : null,
              ),
              Obx(
                () => SwitchListTile(
                  title: Text(_isHourly.value ? 'Hourly Rate' : 'Fixed Amount'),
                  value: _isHourly.value,
                  onChanged: (value) => _isHourly.value = value,
                ),
              ),
              Obx(
                () => _isHourly.value
                    ? TextFormField(
                        controller: _hourlyRateController,
                        decoration: InputDecoration(labelText: 'Hourly Rate'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) => value!.isEmpty
                            ? 'Please enter hourly rate'
                            : double.tryParse(value) == null
                            ? 'Enter a valid number'
                            : null,
                      )
                    : TextFormField(
                        controller: _fixedAmountController,
                        decoration: InputDecoration(labelText: 'Fixed Amount'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) => value!.isEmpty
                            ? 'Please enter fixed amount'
                            : double.tryParse(value) == null
                            ? 'Enter a valid number'
                            : null,
                      ),
              ),
              Obx(
                () => _isHourly.value
                    ? TextFormField(
                        controller: _estimatedHoursController,
                        decoration: InputDecoration(
                          labelText: 'Estimated Hours',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        validator: (value) => value!.isEmpty
                            ? 'Please enter estimated hours'
                            : double.tryParse(value) == null
                            ? 'Enter a valid number'
                            : null,
                      )
                    : SizedBox(),
              ),
              Obx(
                () => ListTile(
                  title: Text('Deadline'),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(_deadline.value),
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _status.value,
                items: ['Ongoing', 'Completed']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) => _status.value = value!,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save Project'),
                onPressed: () => _saveProject(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        id: widget.project?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        clientName: _clientController.text,
        isHourly: _isHourly.value,
        hourlyRate: _isHourly.value
            ? double.parse(_hourlyRateController.text)
            : 0.0,
        fixedAmount: !_isHourly.value
            ? double.parse(_fixedAmountController.text)
            : 0.0,
        estimatedHours: _isHourly.value
            ? double.parse(_estimatedHoursController.text)
            : 0.0,
        deadline: _deadline.value,
        notes: _notesController.text,
        status: _status.value,
        createdAt: widget.project?.createdAt ?? DateTime.now(),
        reminderEnabled: widget.project?.reminderEnabled ?? false,
      );

      try {
        if (widget.project == null) {
          await controller.addProject(project);
        } else {
          await controller.updateProject(project);
        }
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to save project: $e');
      }
    }
  }

  Future<void> _deleteProject() async {
    final confirmed = await Get.dialog(
      AlertDialog(
        title: Text('Delete Project'),
        content: Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Get.back(result: false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.project != null) {
      try {
        await controller.deleteProject(widget.project!.id);
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete project: $e');
      }
    }
  }
}
