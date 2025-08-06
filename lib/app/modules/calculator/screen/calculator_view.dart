import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/calculator_controller.dart';
import 'dart:math' show pi;

class CalculatorView extends GetView<CalculatorController> {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      CalculatorController(),
    ); // Ensure CalculatorController is initialized
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Smart Calculator',
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInputFields()
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.2),
            const SizedBox(height: 28),
            _buildResults().animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
            const SizedBox(height: 28),
            _buildActionButtons()
                .animate()
                .fadeIn(delay: 400.ms)
                .scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField(
                controller: controller.hourlyRateController,
                label: 'Hourly Rate',
                icon: Icons.attach_money,
                onChanged: (value) => controller.calculate(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.hoursController,
                label: 'Hours',
                icon: Icons.timer,
                onChanged: (value) => controller.calculate(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.commissionController,
                label: 'Commission %',
                icon: Icons.percent,
                onChanged: (value) => controller.calculate(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.discountController,
                label: 'Discount %',
                icon: Icons.discount,
                onChanged: (value) => controller.calculate(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
        prefixIcon: Icon(
          icon,
          color: Theme.of(Get.context!).colorScheme.primary,
          size: 22,
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
      ),
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[900],
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildResults() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildResultTile(
                title: 'Total Amount',
                value: controller.totalAmount,
              ),
              const SizedBox(height: 12),
              _buildResultTile(
                title: 'After Commission & Discount',
                value: controller.netAmount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultTile({required String title, required RxDouble value}) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[900],
        ),
      ),
      trailing: Obx(
        () => Text(
          '\$${value.value.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(Get.context!).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'Reset',
            icon: Icons.refresh,
            color: Colors.grey[600]!,
            onPressed: controller.resetFields,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: 'Save',
            icon: Icons.save,
            color: Theme.of(Get.context!).colorScheme.primary,
            onPressed: controller.saveCalculation,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Slight perspective for 3D effect
        ..rotateY(0.05), // Subtle tilt
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
          shadowColor: color.withOpacity(0.3),
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}
