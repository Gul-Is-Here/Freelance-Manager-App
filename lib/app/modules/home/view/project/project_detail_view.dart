import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/services/invoice_service.dart';
import '../../controllers/projects_controller.dart';
import 'dart:math' show pi;

class ProjectDetailView extends StatelessWidget {
  final Project project;

  const ProjectDetailView({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ProjectsController projectsController = Get.find();
    final _formKey = GlobalKey<FormState>();
    final _companyNameController = TextEditingController(
      text: project.companyName ?? '',
    );
    final _companyAddressController = TextEditingController(
      text: project.companyAddress ?? '',
    );
    final _companyEmailController = TextEditingController(
      text: project.companyEmail ?? '',
    );
    final _companyPhoneController = TextEditingController(
      text: project.companyPhone ?? '',
    );

    Future<void> _pickLogo() async {
      try {
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 200,
          maxWidth: 200,
          imageQuality: 85,
        );

        if (image != null) {
          final bytes = await image.readAsBytes();
          final updatedProject = project.copyWith(logoBytes: bytes);
          await projectsController.updateProject(updatedProject);
          Get.snackbar(
            'Success',
            'Logo uploaded successfully.',
            backgroundColor: colorScheme.primary.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to upload logo.',
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }

    Future<void> _saveCompanyDetails() async {
      if (_formKey.currentState!.validate()) {
        try {
          final updatedProject = project.copyWith(
            companyName: _companyNameController.text,
            companyAddress: _companyAddressController.text,
            companyEmail: _companyEmailController.text,
            companyPhone: _companyPhoneController.text,
          );
          await projectsController.updateProject(updatedProject);
          Get.snackbar(
            'Success',
            'Company details saved successfully.',
            backgroundColor: colorScheme.primary.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Failed to save company details.',
            backgroundColor: Colors.red.withOpacity(0.9),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Project Details',
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
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.05),
            alignment: Alignment.center,
            child:
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 28),
                  onPressed: () =>
                      Get.toNamed('/projects/form', arguments: project),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(
                context,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildLogoSection(
                context,
                _pickLogo,
              ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildCompanyDetailsSection(
                context,
                _companyNameController,
                _companyAddressController,
                _companyEmailController,
                _companyPhoneController,
                _saveCompanyDetails,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildDetailsSection(
                context,
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildNotesSection(
                context,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const SizedBox(height: 28),
              _buildInvoiceButton(context)
                  .animate()
                  .fadeIn(delay: 450.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Client: ${project.clientName}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, VoidCallback onPickLogo) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logo',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: project.logoBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            project.logoBytes!,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          ),
                        )
                      : Icon(Icons.image, size: 40, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child:
                      ElevatedButton.icon(
                        icon: Icon(Icons.upload, size: 20, color: Colors.white),
                        label: Text(
                          project.logoBytes != null
                              ? 'Change Logo'
                              : 'Upload Logo',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: onPickLogo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          shadowColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                        ),
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.9, 0.9),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDetailsSection(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController addressController,
    TextEditingController emailController,
    TextEditingController phoneController,
    VoidCallback onSave,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Details',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context: context,
              controller: nameController,
              label: 'Company Name',
              validator: (value) =>
                  value!.isEmpty ? 'Please enter company name' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context: context,
              controller: addressController,
              label: 'Company Address',
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context: context,
              controller: emailController,
              label: 'Company Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context: context,
              controller: phoneController,
              label: 'Company Phone',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d+ ()-]*')),
              ],
              validator: (value) {
                if (value!.isNotEmpty) {
                  final phoneRegex = RegExp(r'^\+?[\d ()-]{7,15}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child:
                  ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                    child: Text(
                      'Save Details',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.9, 0.9),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              label: 'Type',
              value: project.isHourly ? 'Hourly' : 'Fixed Price',
              icon: project.isHourly ? Icons.timer : Icons.request_quote,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: project.isHourly ? 'Hourly Rate' : 'Fixed Amount',
              value:
                  '\$${project.isHourly ? project.hourlyRate.toStringAsFixed(2) : project.fixedAmount.toStringAsFixed(2)}',
              icon: Icons.attach_money,
            ),
            if (project.isHourly) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                label: 'Estimated Hours',
                value: project.estimatedHours.toStringAsFixed(1),
                icon: Icons.hourglass_empty,
              ),
            ],
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: 'Total Amount',
              value: '\$${project.totalAmount.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet,
              isAmount: true,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: 'Status',
              value: project.status,
              icon: project.status == 'Completed'
                  ? Icons.check_circle
                  : Icons.pending,
              valueColor: project.status == 'Completed'
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: 'Deadline',
              value: project.formattedDeadline,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              label: 'Created',
              value: project.formattedCreatedAt,
              icon: Icons.event,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4, -4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project.notes.isEmpty ? 'No notes' : project.notes,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool isAmount = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isAmount ? 16 : 14,
            fontWeight: isAmount ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
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
          prefixIcon: label == 'Company Email'
              ? Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                )
              : label == 'Company Phone'
              ? Icon(
                  Icons.phone,
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
    );
  }

  Widget _buildInvoiceButton(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.05),
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        icon: Icon(Icons.receipt, size: 24, color: Colors.white),
        label: Text(
          'Generate Invoice',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          try {
            Get.find<InvoiceService>().generateAndPrintInvoice(
              project,
              context,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to generate invoice.',
              backgroundColor: Colors.red.withOpacity(0.9),
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
        },
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
      ),
    );
  }
}
