//import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/client_model.dart';
import '../models/client_invoice_model.dart';

class PdfService {
  static Future<void> generateInvoice({
    required Client client,
    required List<Item> items,
    required String invoiceNo,
    required bool isInterState,
    required double gstPercent,
    required String terms,
    required String notes,
  }) async {
    final pdf = pw.Document();
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Calculations
    double subtotal = items.fold(
      0,
      (sum, item) => sum + (item.quantity * item.rate),
    );
    double taxAmount = subtotal * (gstPercent / 100);
    double total = subtotal + taxAmount;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Header: Business Details & Logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "YOUR BUSINESS NAME",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo,
                        ),
                      ),
                      pw.Text(
                        "123 Business Hub, Tech Park\nMumbai, Maharashtra - 400001",
                      ),
                      pw.Text("GSTIN: 27AAAAA0000A1Z5"),
                    ],
                  ),
                  pw.Container(
                    height: 60,
                    width: 60,
                    child: pw.Placeholder(), // Replace with your logo image
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),

              // 2. Invoice Meta & Client Details
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "BILL TO:",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          client.name,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(client.address),
                        pw.Text("GST: ${client.gstNumber}"),
                        pw.Text("Phone: ${client.phone}"),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "Invoice No: $invoiceNo",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text("Date: $date"),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // 3. Items Table
              pw.Table.fromTextArray(
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.indigo,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                headerHeight: 35,
                cellHeight: 32,
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                headers: ['Description', 'Qty', 'Rate', 'Amount'],
                data: items
                    .map(
                      (item) => [
                        item.name,
                        item.quantity.toString(),
                        '₹${item.rate.toStringAsFixed(2)}',
                        '₹${(item.quantity * item.rate).toStringAsFixed(2)}',
                      ],
                    )
                    .toList(),
              ),

              // 4. Totals & Tax
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 200,
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: 10),
                      _totalRow("Subtotal", subtotal),
                      if (!isInterState) ...[
                        _totalRow("CGST (${gstPercent / 2}%)", taxAmount / 2),
                        _totalRow("SGST (${gstPercent / 2}%)", taxAmount / 2),
                      ] else
                        _totalRow("IGST ($gstPercent%)", taxAmount),
                      pw.Divider(),
                      _totalRow("Total Amount", total, isBold: true),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              // 5. Footer: Bank Details & Signature
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Bank Details:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "HDFC Bank | A/C: 50100XXXXXX | IFSC: HDFC0001234",
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          "Terms:",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(terms, style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        height: 50,
                        width: 50,
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data:
                              "upi://pay?pa=yourvpa@bank&am=${total.toStringAsFixed(2)}",
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Scan to Pay",
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        "Authorized Signature",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Container(
                        width: 120,
                        height: 1, // makes the line visible
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(top: pw.BorderSide(width: 1)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Preview or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _totalRow(
    String label,
    double value, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            "Rs ${value.toStringAsFixed(2)}",
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
