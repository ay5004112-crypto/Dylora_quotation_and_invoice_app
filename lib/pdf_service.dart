import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:printing/printing.dart';
import '../models/business_profile.dart';
import '../models/invoice_item.dart';

class PdfService {
  // Brand Color
  static const primaryColor = PdfColor.fromInt(0xff3F51B5); 

  static Future<pw.Document> generateInvoice({
    required BusinessProfile business,
    required List<InvoiceItem> items,
    required String invoiceNum,
    required String date,
    required double gstRate,
    required bool isIgst,
    required String terms,
    String? notes, 
  }) async {
    final pdf = pw.Document();

    // Helper to load images (Logo, Signature, QR, Stamp)
    Future<pw.ImageProvider?> loadPdfImage(String? path) async {
      if (path == null || path.isEmpty) return null;
      try {
        if (kIsWeb) {
          return pw.MemoryImage((await networkImage(path)) as Uint8List);
        } else {
          return pw.MemoryImage(File(path).readAsBytesSync());
        }
      } catch (e) {
        return null;
      }
    }

    final logo = await loadPdfImage(business.logoPath);
    final sign = await loadPdfImage(business.signaturePath);
    final qr = await loadPdfImage(business.qrPath);
    final stamp = await loadPdfImage(business.stampPath);

    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    double tax = subtotal * (gstRate / 100);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(business, logo, invoiceNum, date),
          pw.SizedBox(height: 30),
          _buildInvoiceTable(items),
          pw.SizedBox(height: 20),
          _buildFinancialSummary(subtotal, tax, gstRate, isIgst),
          pw.SizedBox(height: 40),
          _buildBankAndTaxDetails(business, qr, stamp),
          pw.SizedBox(height: 30),
          _buildFooter(terms, notes, sign, business.name),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(BusinessProfile b, pw.ImageProvider? logo, String num, String date) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (logo != null) pw.Container(height: 60, width: 60, child: pw.Image(logo)),
            pw.SizedBox(height: 10),
            pw.Text(b.name.toUpperCase(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: primaryColor)),
            pw.Text(b.address, style: const pw.TextStyle(fontSize: 10)),
            pw.Text("GSTIN: ${b.gst}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.Text("Email: ${b.email}", style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("INVOICE", style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: primaryColor)),
            pw.Text("Invoice No: $num", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text("Date: $date"),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceTable(List<InvoiceItem> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['Description', 'Qty', 'Rate', 'Total'],
      data: items.map((i) => [i.name, '${i.quantity}', 'Rs.${i.price}', 'Rs.${i.total.toStringAsFixed(2)}']).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: primaryColor),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildFinancialSummary(double sub, double tax, double rate, bool isIgst) {
    return pw.Row(
      children: [
        pw.Spacer(flex: 2),
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            children: [
              _summaryRow("Subtotal", sub),
              if (isIgst)
                _summaryRow("IGST ($rate%)", tax)
              else ...[
                _summaryRow("CGST (${rate / 2}%)", tax / 2),
                _summaryRow("SGST (${rate / 2}%)", tax / 2),
              ],
              pw.Divider(color: PdfColors.grey400),
              _summaryRow("Total Payable", sub + tax, isBold: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _summaryRow(String label, double amount, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : null)),
          pw.Text("Rs.${amount.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : null)),
        ],
      ),
    );
  }

  static pw.Widget _buildBankAndTaxDetails(BusinessProfile b, pw.ImageProvider? qr, pw.ImageProvider? stamp) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("BANK DETAILS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: primaryColor)),
          pw.Text("Bank Name: ${b.bankName}", style: const pw.TextStyle(fontSize: 9)),
          pw.Text("Account Name: ${b.accountName}", style: const pw.TextStyle(fontSize: 9)),
          pw.Text("A/C Number: ${b.accountNumber}", style: const pw.TextStyle(fontSize: 9)),
          pw.Text("IFSC Code: ${b.ifsc}", style: const pw.TextStyle(fontSize: 9)),
        ]),
        pw.Row(children: [
          if (qr != null) pw.Container(height: 70, width: 70, child: pw.Image(qr)),
          pw.SizedBox(width: 10),
          if (stamp != null) pw.Container(height: 70, width: 70, child: pw.Image(stamp)),
        ]),
      ],
    );
  }

  static pw.Widget _buildFooter(String terms, String? notes, pw.ImageProvider? sign, String bizName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Terms & Conditions:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.Text(terms, style: const pw.TextStyle(fontSize: 8)),
              if (notes != null && notes.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Text("Notes: $notes", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
              ]
            ],
          ),
        ),
        pw.Column(
          children: [
            if (sign != null) pw.Container(height: 40, width: 80, child: pw.Image(sign)),
            pw.Container(width: 120, height: 1, color: PdfColors.black),
            pw.Text("Authorized Signatory", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            pw.Text(bizName, style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }
}