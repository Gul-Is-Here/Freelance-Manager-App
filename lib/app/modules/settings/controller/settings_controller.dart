import 'package:flutter/material.dart' show ThemeMode;
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../data/services/local_storage_service.dart';

class SettingsController extends GetxController {
  final LocalStorageService _localStorage = Get.find();
  var isBiometricEnabled = false.obs;
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Default settings values
  var defaultHourlyRate = 0.0.obs;
  var defaultCommission = 0.0.obs;
  var defaultTax = 0.0.obs;
  var currency = 'USD'.obs;
  var isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      isBiometricEnabled.value =
          canCheck && _localStorage.getBool('isBiometricEnabled', false);
    } catch (e) {
      print('Biometric check error: $e');
    }
  }

  Future<void> toggleBiometricAuth(bool value) async {
    if (value) {
      try {
        final authenticated = await _localAuth.authenticate(
          localizedReason: 'Authenticate to enable biometric lock',
        );
        if (authenticated) {
          await _localStorage.setBool('isBiometricEnabled', true);
          isBiometricEnabled.value = true;
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to enable biometric authentication: $e');
      }
    } else {
      await _localStorage.setBool('isBiometricEnabled', false);
      isBiometricEnabled.value = false;
    }
  }

  Future<void> _loadSettings() async {
    defaultHourlyRate.value = _localStorage.getDouble(
      'defaultHourlyRate',
      25.0,
    );
    defaultCommission.value = _localStorage.getDouble(
      'defaultCommission',
      10.0,
    );
    defaultTax.value = _localStorage.getDouble('defaultTax', 0.0);
    currency.value = _localStorage.getString('currency', 'USD');
    isDarkMode.value = _localStorage.getBool('isDarkMode', false);
  }

  Future<void> saveHourlyRate(double value) async {
    await _localStorage.setDouble('defaultHourlyRate', value);
    defaultHourlyRate.value = value;
  }

  Future<void> saveCommission(double value) async {
    await _localStorage.setDouble('defaultCommission', value);
    defaultCommission.value = value;
  }

  Future<void> saveTax(double value) async {
    await _localStorage.setDouble('defaultTax', value);
    defaultTax.value = value;
  }

  Future<void> saveCurrency(String value) async {
    await _localStorage.setString('currency', value);
    currency.value = value;
  }

  Future<void> toggleTheme(bool value) async {
    await _localStorage.setBool('isDarkMode', value);
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
