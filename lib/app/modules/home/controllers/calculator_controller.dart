import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/models/calculation_model.dart';
import '../../../../data/services/database_service.dart';

class CalculatorController extends GetxController {
  final DatabaseService _databaseService = Get.find();

  var hourlyRateController = TextEditingController();
  var hoursController = TextEditingController();
  var commissionController = TextEditingController();
  var discountController = TextEditingController();

  var totalAmount = 0.0.obs;
  var netAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values or empty
    hourlyRateController.text = '';
    hoursController.text = '';
    commissionController.text = '0';
    discountController.text = '0';
  }

  @override
  void onClose() {
    hourlyRateController.dispose();
    hoursController.dispose();
    commissionController.dispose();
    discountController.dispose();
    super.onClose();
  }

  void calculate() {
    try {
      double rate = double.tryParse(hourlyRateController.text) ?? 0;
      double hours = double.tryParse(hoursController.text) ?? 0;
      double commission = double.tryParse(commissionController.text) ?? 0;
      double discount = double.tryParse(discountController.text) ?? 0;

      totalAmount.value = rate * hours;
      
      double commissionAmount = totalAmount.value * (commission / 100);
      double discountAmount = totalAmount.value * (discount / 100);
      
      netAmount.value = totalAmount.value - commissionAmount - discountAmount;
    } catch (e) {
      print('Error in calculation: $e');
    }
  }

  void resetFields() {
    hourlyRateController.text = '';
    hoursController.text = '';
    commissionController.text = '0';
    discountController.text = '0';
    totalAmount.value = 0.0;
    netAmount.value = 0.0;
  }

  Future<void> saveCalculation() async {
    if (totalAmount.value <= 0) {
      Get.snackbar('Error', 'Nothing to save. Total amount is zero.');
      return;
    }

    try {
      double rate = double.tryParse(hourlyRateController.text) ?? 0;
      double hours = double.tryParse(hoursController.text) ?? 0;
      double commission = double.tryParse(commissionController.text) ?? 0;
      double discount = double.tryParse(discountController.text) ?? 0;

      final calculation = Calculation(
        id: Uuid().v4(),
        hourlyRate: rate,
        hours: hours,
        commission: commission,
        discount: discount,
        total: totalAmount.value,
        netAmount: netAmount.value,
        createdAt: DateTime.now(),
      );

      final db = await _databaseService.database;
      await db.insert('calculations', calculation.toMap());

      Get.snackbar('Success', 'Calculation saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save calculation: $e');
    }
  }
}