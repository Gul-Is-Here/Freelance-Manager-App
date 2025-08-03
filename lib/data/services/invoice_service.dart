import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/project_model.dart';
import 'package:printing/printing.dart';

class InvoiceService {
  Future<void> generateAndPrintInvoice(
    Project project,
    BuildContext context,
  ) async {
    try {
      final pdf = pw.Document();
      final fontRegular = await PdfGoogleFonts.openSansRegular();
      final fontMedium = await PdfGoogleFonts.openSansSemiBold();
      final fontBold = await PdfGoogleFonts.openSansBold();
      final colorScheme = Theme.of(context).colorScheme;
      final primaryColor = PdfColor.fromInt(colorScheme.primary.value);
      final accentColor = PdfColor.fromInt(colorScheme.secondary.value);
      final gradientStart = PdfColor.fromInt(
        colorScheme.primary.withOpacity(0.1).value,
      );
      final gradientEnd = PdfColor.fromInt(
        colorScheme.primary.withOpacity(0.05).value,
      );

      // Invoice metadata
      final invoiceNumber = 'INV-${project.id.substring(0, 8).toUpperCase()}';
      final invoiceDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
      final dueDate = DateFormat(
        'MMMM dd, yyyy',
      ).format(DateTime.now().add(const Duration(days: 30)));
      final currencyFormatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 2,
      );

      // Build PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (context) => _buildInvoiceHeader(
            context,
            project,
            fontBold,
            fontMedium,
            primaryColor,
            accentColor,
            invoiceNumber,
            invoiceDate,
          ),
          footer: (context) =>
              _buildInvoiceFooter(context, fontMedium, primaryColor, dueDate),
          build: (context) => [
            pw.SizedBox(height: 20),
            _buildInvoiceTitle(project, fontBold, primaryColor),
            pw.SizedBox(height: 24),
            _buildClientDetails(
              project,
              fontMedium,
              gradientStart,
              gradientEnd,
            ),
            pw.SizedBox(height: 32),
            _buildInvoiceItemsTable(
              project,
              fontMedium,
              fontBold,
              primaryColor,
              accentColor,
              currencyFormatter,
            ),
            pw.SizedBox(height: 32),
            _buildPaymentSummary(
              project,
              fontMedium,
              fontBold,
              primaryColor,
              currencyFormatter,
            ),
            pw.SizedBox(height: 32),
            _buildProjectNotes(project, fontMedium, primaryColor),
            pw.SizedBox(height: 20),
          ],
        ),
      );

      // Print or share the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      Get.snackbar(
        'Success',
        'Invoice generated successfully',
        backgroundColor: colorScheme.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate invoice: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  pw.Widget _buildInvoiceHeader(
    pw.Context context,
    Project project,
    pw.Font fontBold,
    pw.Font fontMedium,
    PdfColor primaryColor,
    PdfColor accentColor,
    String invoiceNumber,
    String invoiceDate,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 16),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo or placeholder
              project.logoBytes != null
                  ? pw.ClipRRect(
                      horizontalRadius: 8,
                      verticalRadius: 8,
                      child: pw.Image(
                        pw.MemoryImage(project.logoBytes!),
                        width: 80,
                        height: 80,
                        fit: pw.BoxFit.contain,
                      ),
                    )
                  : pw.Container(
                      width: 80,
                      height: 80,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'LOGO',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 14,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ),
                    ),
              pw.SizedBox(height: 12),
              pw.Text(
                project.companyName ?? 'Freelance Hub',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 24,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 8),
              if (project.companyAddress != null)
                pw.Text(
                  project.companyAddress!,
                  style: pw.TextStyle(
                    font: fontMedium,
                    fontSize: 11,
                    color: PdfColors.grey700,
                    lineSpacing: 1.2,
                  ),
                ),
              if (project.companyEmail != null)
                pw.Text(
                  'Email: ${project.companyEmail}',
                  style: pw.TextStyle(
                    font: fontMedium,
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
              if (project.companyPhone != null)
                pw.Text(
                  'Phone: ${project.companyPhone}',
                  style: pw.TextStyle(
                    font: fontMedium,
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 28,
                  color: accentColor,
                  letterSpacing: 1.2,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: primaryColor,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text(
                  'Invoice #: $invoiceNumber',
                  style: pw.TextStyle(
                    font: fontMedium,
                    fontSize: 12,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Date: $invoiceDate',
                style: pw.TextStyle(
                  font: fontMedium,
                  fontSize: 12,
                  color: PdfColors.grey800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceFooter(
    pw.Context context,
    pw.Font fontMedium,
    PdfColor primaryColor,
    String dueDate,
  ) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Column(
        children: [
          pw.Divider(color: primaryColor, thickness: 1.5),
          pw.SizedBox(height: 12),
          pw.Text(
            'Payment due by $dueDate',
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 11,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 12,
              color: primaryColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Contact us for any inquiries',
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceTitle(
    Project project,
    pw.Font fontBold,
    PdfColor primaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Invoice for ${project.clientName}',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 20,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Project: ${project.title}',
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 14,
            color: PdfColors.grey800,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildClientDetails(
    Project project,
    pw.Font fontMedium,
    PdfColor gradientStart,
    PdfColor gradientEnd,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'BILL TO',
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 12,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            project.clientName,
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 14,
              color: PdfColors.grey900,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceItemsTable(
    Project project,
    pw.Font fontMedium,
    pw.Font fontBold,
    PdfColor primaryColor,
    PdfColor accentColor,
    NumberFormat currencyFormatter,
  ) {
    return pw.Table(
      border: null,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: primaryColor,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                'DESCRIPTION',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                'QTY/HRS',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                'RATE',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                'AMOUNT',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ),
          ],
        ),
        // Spacer
        pw.TableRow(
          children: [
            pw.SizedBox(height: 4),
            pw.SizedBox(height: 4),
            pw.SizedBox(height: 4),
            pw.SizedBox(height: 4),
          ],
        ),
        // Item row
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                project.title,
                style: pw.TextStyle(
                  font: fontMedium,
                  fontSize: 11,
                  color: PdfColors.grey800,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                project.isHourly
                    ? project.estimatedHours.toStringAsFixed(1)
                    : '1',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontMedium,
                  fontSize: 11,
                  color: PdfColors.grey800,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                currencyFormatter.format(
                  project.isHourly ? project.hourlyRate : project.fixedAmount,
                ),
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontMedium,
                  fontSize: 11,
                  color: PdfColors.grey800,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                currencyFormatter.format(project.totalAmount),
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: fontMedium,
                  fontSize: 11,
                  color: PdfColors.grey800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPaymentSummary(
    Project project,
    pw.Font fontMedium,
    pw.Font fontBold,
    PdfColor primaryColor,
    NumberFormat currencyFormatter,
  ) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 220,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(12),
          border: pw.Border.all(color: primaryColor, width: 1),
        ),
        child: pw.Table(
          border: null,
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Text(
                    'Subtotal',
                    style: pw.TextStyle(
                      font: fontMedium,
                      fontSize: 12,
                      color: PdfColors.grey800,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Text(
                    currencyFormatter.format(project.totalAmount),
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      font: fontMedium,
                      fontSize: 12,
                      color: PdfColors.grey800,
                    ),
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Text(
                    currencyFormatter.format(project.totalAmount),
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                      color: primaryColor,
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

  pw.Widget _buildProjectNotes(
    Project project,
    pw.Font fontMedium,
    PdfColor primaryColor,
  ) {
    if (project.notes.isEmpty) return pw.SizedBox.shrink();

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border(left: pw.BorderSide(color: primaryColor, width: 4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes',
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 12,
              color: PdfColors.grey800,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            project.notes,
            style: pw.TextStyle(
              font: fontMedium,
              fontSize: 11,
              color: PdfColors.grey700,
              lineSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
