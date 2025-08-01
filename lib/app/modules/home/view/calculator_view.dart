import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class CalculatorView extends GetView<CalculatorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputFields(),
            SizedBox(height: 20),
            _buildResults(),
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: controller.hourlyRateController,
              decoration: InputDecoration(
                labelText: 'Hourly Rate',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.calculate(),
            ),
            TextFormField(
              controller: controller.hoursController,
              decoration: InputDecoration(
                labelText: 'Hours',
                prefixIcon: Icon(Icons.timer),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.calculate(),
            ),
            TextFormField(
              controller: controller.commissionController,
              decoration: InputDecoration(
                labelText: 'Commission %',
                prefixIcon: Icon(Icons.percent),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.calculate(),
            ),
            TextFormField(
              controller: controller.discountController,
              decoration: InputDecoration(
                labelText: 'Discount %',
                prefixIcon: Icon(Icons.discount),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.calculate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('Total Amount'),
              trailing: Obx(() => Text(
                    '\$${controller.totalAmount.value.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
            ListTile(
              title: Text('After Commission & Discount'),
              trailing: Obx(() => Text(
                    '\$${controller.netAmount.value.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text('Reset'),
            onPressed: controller.resetFields,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Save'),
            onPressed: controller.saveCalculation,
          ),
        ),
      ],
    );
  }
}