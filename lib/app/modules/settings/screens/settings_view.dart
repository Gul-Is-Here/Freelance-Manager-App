import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../controller/settings_controller.dart';
import '../../home/home/controller/theme_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    final ThemeController themeController = Get.find<ThemeController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Preferences',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  context,
                  icon: Icons.calculate_rounded,
                  title: 'Calculator Defaults',
                  children: [
                    _buildSettingInput(
                      context,
                      icon: Icons.attach_money,
                      label: 'Hourly Rate',
                      value: controller.defaultHourlyRate.value.toString(),
                      onChanged: (value) {
                        final rate = double.tryParse(value);
                        if (rate != null) controller.saveHourlyRate(rate);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingInput(
                      context,
                      icon: Icons.percent,
                      label: 'Commission %',
                      value: controller.defaultCommission.value.toString(),
                      onChanged: (value) {
                        final commission = double.tryParse(value);
                        if (commission != null)
                          controller.saveCommission(commission);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingInput(
                      context,
                      icon: Icons.request_quote,
                      label: 'Tax %',
                      value: controller.defaultTax.value.toString(),
                      onChanged: (value) {
                        final tax = double.tryParse(value);
                        if (tax != null) controller.saveTax(tax);
                      },
                    ),
                  ],
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  icon: Icons.palette_rounded,
                  title: 'Appearance',
                  children: [
                    Text(
                      'Theme Colors',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildThemeOption(
                          context,
                          color: Colors.teal,
                          isSelected:
                              themeController.currentTheme.value == 'default',
                          onTap: () => themeController.switchTheme('default'),
                        ),
                        _buildThemeOption(
                          context,
                          color: Colors.pink,
                          isSelected:
                              themeController.currentTheme.value == 'pink',
                          onTap: () => themeController.switchTheme('pink'),
                        ),
                        _buildThemeOption(
                          context,
                          color: themeController
                              .currentThemeData
                              .value
                              .primaryColor,
                          isSelected:
                              themeController.currentTheme.value == 'custom',
                          onTap: () => _showCustomColorPicker(context),
                          isCustom: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildSettingToggle(
                        context,
                        icon: controller.isDarkMode.value
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        label: 'Dark Mode',
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleTheme,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  icon: Icons.security_rounded,
                  title: 'Security & Currency',
                  children: [
                    _buildCurrencyDropdown(context),
                    const SizedBox(height: 16),
                    Obx(
                      () => controller.isBiometricEnabled.value != null
                          ? _buildSettingToggle(
                              context,
                              icon: Icons.fingerprint_rounded,
                              label: 'Biometric Lock',
                              value: controller.isBiometricEnabled.value,
                              onChanged: controller.toggleBiometricAuth,
                            )
                          : const SizedBox(),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingInput(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey[900],
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    bool isCustom = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.grey[900]!, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            isSelected ? Icons.check : (isCustom ? Icons.colorize : null),
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingToggle(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            ),
            Transform.scale(
              scale: 0.8,
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
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: controller.currency.value,
          items: ['USD', 'EUR', 'GBP', 'JPY', 'CAD'].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.saveCurrency(value);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.currency_exchange_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            labelText: 'Currency',
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey[900],
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showCustomColorPicker(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    Color pickerPrimaryColor =
        themeController.currentThemeData.value.primaryColor;
    Color pickerSecondaryColor =
        themeController.currentThemeData.value.colorScheme.secondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Custom Theme',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Primary Color',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            BlockPicker(
              pickerColor: pickerPrimaryColor,
              onColorChanged: (color) => pickerPrimaryColor = color,
              availableColors: const [
                Colors.red,
                Colors.pink,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.blue,
                Colors.lightBlue,
                Colors.cyan,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
                Colors.brown,
              ],
              layoutBuilder: (context, colors, child) {
                return SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (Color color in colors) child(color)],
                  ),
                );
              },
              itemBuilder: (color, isCurrentColor, changeColor) {
                return GestureDetector(
                  onTap: changeColor,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isCurrentColor
                          ? Border.all(color: Colors.grey[900]!, width: 2)
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Secondary Color',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            BlockPicker(
              pickerColor: pickerSecondaryColor,
              onColorChanged: (color) => pickerSecondaryColor = color,
              availableColors: const [
                Colors.red,
                Colors.pink,
                Colors.purple,
                Colors.deepPurple,
                Colors.indigo,
                Colors.blue,
                Colors.lightBlue,
                Colors.cyan,
                Colors.teal,
                Colors.green,
                Colors.lightGreen,
                Colors.lime,
                Colors.yellow,
                Colors.amber,
                Colors.orange,
                Colors.deepOrange,
                Colors.brown,
              ],
              layoutBuilder: (context, colors, child) {
                return SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (Color color in colors) child(color)],
                  ),
                );
              },
              itemBuilder: (color, isCurrentColor, changeColor) {
                return GestureDetector(
                  onTap: changeColor,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isCurrentColor
                          ? Border.all(color: Colors.grey[900]!, width: 2)
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      themeController.setCustomTheme(
                        pickerPrimaryColor,
                        pickerSecondaryColor,
                      );
                      Navigator.pop(context);
                      Get.snackbar(
                        'Success',
                        'Custom theme applied',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
