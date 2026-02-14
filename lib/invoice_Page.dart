import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:quotation_invoice/pdf_service.dart';
import '../models/business_profile.dart';
import '../models/invoice_item.dart';

class InvoicePage extends StatefulWidget {
  final BusinessProfile business;
  const InvoicePage({super.key, required this.business});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final Color primaryColor = const Color(0xff6366f1);
  final Color slate800 = const Color(0xff1e293b);

  late String invoiceNumber;
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<InvoiceItem> items = [InvoiceItem(name: "", quantity: 1, price: 0)];
  double gstPercentage = 18.0;
  bool isIgst = false;

  final termsController = TextEditingController(text: "1. Goods once sold will not be taken back.");
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    invoiceNumber = "INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * (gstPercentage / 100);
  double get totalPayable => subtotal + taxAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        title: const Text("Generate Invoice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
                _buildItemSection(),
                const SizedBox(height: 24),
                _buildTaxSettings(),
                const SizedBox(height: 16),
                TextField(controller: termsController, decoration: const InputDecoration(labelText: "Terms", filled: true, fillColor: Colors.white)),
              ],
            ),
          ),
          _buildBottomActionPanel(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.business.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
          Text("GSTIN: ${widget.business.gst}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
          const Divider(),
          Text("Invoice No: $invoiceNumber", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildItemSection() {
    return Column(
      children: [
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          return Card(
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(hintText: "Item Name", border: InputBorder.none),
                onChanged: (v) => items[index].name = v,
              ),
              subtitle: Row(
                children: [
                  Expanded(child: TextField(decoration: const InputDecoration(labelText: "Qty"), keyboardType: TextInputType.number, onChanged: (v) => setState(() => items[index].quantity = int.tryParse(v) ?? 1))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number, onChanged: (v) => setState(() => items[index].price = double.tryParse(v) ?? 0))),
                ],
              ),
              trailing: IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => setState(() => items.removeAt(index))),
            ),
          );
        }),
        TextButton.icon(onPressed: () => setState(() => items.add(InvoiceItem(name: ""))), icon: const Icon(Icons.add), label: const Text("Add Item")),
      ],
    );
  }

  Widget _buildTaxSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: slate800, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("IGST", style: TextStyle(color: Colors.white)), Switch(value: isIgst, onChanged: (v) => setState(() => isIgst = v))]),
        TextField(style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "GST Rate %", labelStyle: TextStyle(color: Colors.white)), keyboardType: TextInputType.number, onChanged: (v) => setState(() => gstPercentage = double.tryParse(v) ?? 0)),
      ]),
    );
  }

  Widget _buildBottomActionPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Total"), Text("₹${totalPayable.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () async {
                final pdf = await PdfService.generateInvoice(business: widget.business, items: items, invoiceNum: invoiceNumber, date: currentDate, gstRate: gstPercentage, isIgst: isIgst, terms: termsController.text);
                await Printing.layoutPdf(onLayout: (f) => pdf.save());
              },
              child: const Text("SAVE PDF", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}