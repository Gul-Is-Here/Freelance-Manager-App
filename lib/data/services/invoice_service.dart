import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/project_model.dart';

class InvoiceService {
  Future<void> generateAndPrintInvoice(Project project) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('INVOICE')),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('From:'),
                      pw.Text('Your Name'),
                      pw.Text('Your Address'),
                      pw.Text('Your Email'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('To:'),
                      pw.Text(project.clientName),
                      pw.Text('Project: ${project.title}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text('Description'),
                        padding: pw.EdgeInsets.all(8),
                      ),
                      pw.Padding(
                        child: pw.Text('Amount'),
                        padding: pw.EdgeInsets.all(8),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        child: pw.Text(project.title),
                        padding: pw.EdgeInsets.all(8),
                      ),
                      pw.Padding(
                        child: pw.Text(
                            '\$${project.totalAmount.toStringAsFixed(2)}'),
                        padding: pw.EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total: \$${project.totalAmount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text('Thank you for your business!'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}