import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/project_model.dart';
import '../controller/projects_controller.dart';
import 'dart:math' show pi;

class ProjectFormView extends StatefulWidget {
  final Project? project;

  const ProjectFormView({this.project, super.key});

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
  final _deadline = DateTime.now().add(const Duration(days: 7)).obs;

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.grey[50],
              onSurface: Colors.grey[900],
            ),
            textTheme: TextTheme(
              bodyMedium: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
              titleMedium: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            dialogBackgroundColor: Colors.grey[50],
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _deadline.value) {
      setState(() {
        _deadline.value = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.project == null ? 'Add Project' : 'Edit Project',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        actions: [
          if (widget.project != null)
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.05),
              alignment: Alignment.center,
              child:
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => _deleteProject(),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.9, 0.9),
                  ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Project Title',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _clientController,
                label: 'Client Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter client name' : null,
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              Obx(
                () => _buildSwitchTile(
                  title: _isHourly.value ? 'Hourly Rate' : 'Fixed Amount',
                  value: _isHourly.value,
                  onChanged: (value) => _isHourly.value = value,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _isHourly.value
                    ? _buildTextField(
                        controller: _hourlyRateController,
                        label: 'Hourly Rate',
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
                      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2)
                    : _buildTextField(
                        controller: _fixedAmountController,
                        label: 'Fixed Amount',
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
                      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _isHourly.value
                    ? _buildTextField(
                        controller: _estimatedHoursController,
                        label: 'Estimated Hours',
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
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2)
                    : const SizedBox(),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _buildDateTile(
                  title: 'Deadline',
                  subtitle: DateFormat('MMM dd, yyyy').format(_deadline.value),
                  onTap: () => _selectDate(context),
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _status.value,
                items: ['Ongoing', 'Completed'],
                label: 'Status',
                onChanged: (value) => _status.value = value!,
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: 'Notes',
                maxLines: 3,
              ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildSaveButton()
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            filled: true,
            fillColor: Colors.grey[200]!.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: label == 'Hourly Rate' || label == 'Fixed Amount'
                ? Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  )
                : label == 'Estimated Hours'
                ? Icon(
                    Icons.timer,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  )
                : null,
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[900],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                child: Icon(
                  value ? Icons.attach_money : Icons.request_quote,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Theme.of(context).colorScheme.primary,
                  activeTrackColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String) onChanged,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => onChanged(value!),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            filled: true,
            fillColor: Colors.grey[200]!.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: Icon(
              Icons.list_alt,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[900],
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => _saveProject(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
        child: Text(
          'Save Project',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
        createdAt: widget.project?.createdAt ?? DateTime.now().toUtc(),
        reminderEnabled: widget.project?.reminderEnabled ?? false,
      );

      try {
        if (widget.project == null) {
          await controller.addProject(project);
          Get.snackbar(
            'Success',
            'Project added successfully.',
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          await controller.loadProjects();
          Navigator.of(context).pop();
        } else {
          await controller.updateProject(project);
          Get.snackbar(
            'Success',
            'Project updated successfully.',
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save project.',
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  Future<void> _deleteProject() async {
    final confirmed = await Get.dialog(
      Dialog(
        backgroundColor: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.delete_outline,
                  size: 32,
                  color: Colors.red[600],
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              Text(
                'Delete Project',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete this project?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child:
                        OutlinedButton(
                              onPressed: () => Get.back(result: false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey[400]!),
                                foregroundColor: Colors.grey[900],
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        ElevatedButton(
                              onPressed: () {
                                Get.back(result: true);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: Colors.red.withOpacity(0.3),
                              ),
                              child: Text(
                                'Delete',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && widget.project != null) {
      try {
        await controller.deleteProject(widget.project!.id);
        Get.snackbar(
          'Success',
          'Project deleted successfully.',
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Navigator.of(context).pop();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete project.',
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }
}
