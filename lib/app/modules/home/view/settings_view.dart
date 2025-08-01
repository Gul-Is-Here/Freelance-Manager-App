import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculator Defaults',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.defaultHourlyRate.value
                            .toString(),
                        decoration: InputDecoration(
                          labelText: 'Default Hourly Rate',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final rate = double.tryParse(value);
                          if (rate != null) {
                            controller.saveHourlyRate(rate);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.defaultCommission.value
                            .toString(),
                        decoration: InputDecoration(
                          labelText: 'Default Commission %',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final commission = double.tryParse(value);
                          if (commission != null) {
                            controller.saveCommission(commission);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.defaultTax.value.toString(),
                        decoration: InputDecoration(labelText: 'Default Tax %'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final tax = double.tryParse(value);
                          if (tax != null) {
                            controller.saveTax(tax);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => SwitchListTile(
                        title: Text('Dark Mode'),
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleTheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currency',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.currency.value,
                        items: ['USD', 'EUR', 'GBP', 'JPY', 'CAD']
                            .map(
                              (currency) => DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.saveCurrency(value);
                          }
                        },
                        decoration: InputDecoration(labelText: 'Currency'),
                      ),
                    ),
                    Obx(
                      () => controller.isBiometricEnabled.value != null
                          ? SwitchListTile(
                              title: Text('Biometric Lock'),
                              value: controller.isBiometricEnabled.value,
                              onChanged: controller.toggleBiometricAuth,
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
