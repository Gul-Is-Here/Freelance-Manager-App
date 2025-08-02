import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../../../../data/models/calculation_model.dart';
import '../../../../data/services/database_service.dart';

class CalculatorController extends GetxController {
  final DatabaseService _databaseService = Get.find();

  // Text controllers for input fields
  final hourlyRateController = TextEditingController();
  final hoursController = TextEditingController();
  final commissionController = TextEditingController();
  final discountController = TextEditingController();

  // Observable variables for calculation results
  final totalAmount = 0.0.obs;
  final netAmount = 0.0.obs;

  // Debounce timer to prevent excessive calculations
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values
    hourlyRateController.text = '';
    hoursController.text = '';
    commissionController.text = '0';
    discountController.text = '0';

    // Add listeners to trigger debounced calculations
    hourlyRateController.addListener(_debouncedCalculate);
    hoursController.addListener(_debouncedCalculate);
    commissionController.addListener(_debouncedCalculate);
    discountController.addListener(_debouncedCalculate);
  }

  @override
  void onClose() {
    // Clean up debounce timer
    _debounceTimer?.cancel();
    // Dispose text controllers
    hourlyRateController.dispose();
    hoursController.dispose();
    commissionController.dispose();
    discountController.dispose();
    super.onClose();
  }

  /// Debounces the calculate method to avoid excessive updates
  void _debouncedCalculate() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), calculate);
  }

  /// Calculates total and net amounts based on input values
  void calculate() {
    try {
      // Parse inputs with empty string handling
      final rate = _parseDouble(hourlyRateController.text);
      final hours = _parseDouble(hoursController.text);
      final commission = _parseDouble(commissionController.text);
      final discount = _parseDouble(discountController.text);

      // Validate inputs
      if (rate < 0 || hours < 0 || commission < 0 || discount < 0) {
        Get.snackbar(
          'Invalid Input',
          'Values cannot be negative.',
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        totalAmount.value = 0.0;
        netAmount.value = 0.0;
        return;
      }

      // Perform calculations
      totalAmount.value = rate * hours;
      final commissionAmount = totalAmount.value * (commission / 100);
      final discountAmount = totalAmount.value * (discount / 100);
      netAmount.value = (totalAmount.value - commissionAmount - discountAmount).clamp(0, double.infinity);

      // Show warning if net amount is negative
      if (netAmount.value < 0) {
        Get.snackbar(
          'Warning',
          'Net amount is negative due to high commission or discount.',
          backgroundColor: Colors.orange.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint('Calculation error: $e');
      Get.snackbar(
        'Error',
        'Invalid input format. Please enter valid numbers.',
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      totalAmount.value = 0.0;
      netAmount.value = 0.0;
    }
  }

  /// Parses a string to double, handling empty or invalid inputs
  double _parseDouble(String value) {
    if (value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  /// Resets all input fields and calculated values
  void resetFields() {
    hourlyRateController.text = '';
    hoursController.text = '';
    commissionController.text = '0';
    discountController.text = '0';
    totalAmount.value = 0.0;
    netAmount.value = 0.0;
    Get.snackbar(
      'Reset',
      'Fields cleared successfully.',
      backgroundColor: Colors.grey[600]!.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Saves the current calculation to the database
  Future<void> saveCalculation() async {
    if (totalAmount.value <= 0) {
      Get.snackbar(
        'Error',
        'Nothing to save. Total amount is zero.',
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      final rate = _parseDouble(hourlyRateController.text);
      final hours = _parseDouble(hoursController.text);
      final commission = _parseDouble(commissionController.text);
      final discount = _parseDouble(discountController.text);

      // Validate inputs before saving
      if (rate < 0 || hours < 0 || commission < 0 || discount < 0) {
        Get.snackbar(
          'Invalid Input',
          'Values cannot be negative.',
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final calculation = Calculation(
        id: const Uuid().v4(),
        hourlyRate: rate,
        hours: hours,
        commission: commission,
        discount: discount,
        total: totalAmount.value,
        netAmount: netAmount.value,
        createdAt: DateTime.now().toUtc(), // Use UTC for consistency
      );

      final db = await _databaseService.database;
      await db.insert('calculations', calculation.toMap());

      Get.snackbar(
        'Success',
        'Calculation saved successfully.',
        backgroundColor: Get.theme.primaryColor.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      debugPrint('Save calculation error: $e');
      Get.snackbar(
        'Error',
        'Failed to save calculation.',
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}