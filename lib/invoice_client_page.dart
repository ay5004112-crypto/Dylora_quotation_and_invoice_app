import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:quotation_invoice/client_pdf_service.dart";
import '../models/client_model.dart';
import '../models/client_invoice_model.dart';

class ItemSelectionPage extends StatefulWidget {
  final Client client;
  const ItemSelectionPage({super.key, required this.client});

  @override
  State<ItemSelectionPage> createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  // Styles & Colors
  final Color primaryColor = const Color(0xff6366f1);
  final Color slate800 = const Color(0xff1e293b);
  final Color slate500 = const Color(0xff64748b);

  // Data State
  List<Item> items = [];
  String invoiceNumber =
      "INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
  DateTime selectedDate = DateTime.now();
  bool isInterState = false; // Toggle between CGST/SGST and IGST
  double gstPercentage = 18.0;

  TextEditingController termsController = TextEditingController(
    text:
        "1. Goods once sold will not be taken back.\n2. Interest @18% will be charged if not paid within 7 days.",
  );
  TextEditingController notesController = TextEditingController();

  // Totals Calculation logic
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * (gstPercentage / 100);
  double get totalAmount => subtotal + taxAmount;

  void _addItem() {
    setState(() {
      items.add(Item(name: "", quantity: 1, rate: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        title: const Text(
          "Create Quotation",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, const Color(0xff4338ca)],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildSectionTitle("Line Items"),
            _buildItemList(),
            _buildAddItemButton(),
            const SizedBox(height: 20),
            _buildTaxAndTotals(),
            const SizedBox(height: 20),
            _buildAdditionalFields(),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: _buildBottomSummary(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: slate800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Invoice #", invoiceNumber, Icons.numbers),
              _infoTile(
                "Date",
                DateFormat('dd MMM yyyy').format(selectedDate),
                Icons.calendar_month,
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.client.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.client.email,
                    style: TextStyle(color: slate500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: slate500, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: primaryColor),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Item name",
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => items[index].name = v,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => setState(() => items.removeAt(index)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _miniField(
                        "Qty",
                        (v) => setState(
                          () => items[index].quantity = double.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _miniField(
                        "Rate",
                        (v) => setState(
                          () => items[index].rate = double.tryParse(v) ?? 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontSize: 12, color: slate500),
                          ),
                          Text(
                            "₹${items[index].total.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _miniField(String label, Function(String) onChange) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, isDense: true),
      onChanged: onChange,
    );
  }

  Widget _buildAddItemButton() {
    return TextButton.icon(
      onPressed: _addItem,
      icon: const Icon(Icons.add_circle_outline),
      label: const Text("Add New Item"),
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    );
  }

  Widget _buildTaxAndTotals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: slate800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _totalRow(
            "Subtotal",
            "₹${subtotal.toStringAsFixed(2)}",
            Colors.white70,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Inter-state (IGST)",
                style: const TextStyle(color: Colors.white70),
              ),
              Switch(
                value: isInterState,
                onChanged: (v) => setState(() => isInterState = v),
                activeColor: Colors.white,
              ),
            ],
          ),
          if (!isInterState) ...[
            _totalRow(
              "CGST (${gstPercentage / 2}%)",
              "₹${(taxAmount / 2).toStringAsFixed(2)}",
              Colors.white70,
            ),
            _totalRow(
              "SGST (${gstPercentage / 2}%)",
              "₹${(taxAmount / 2).toStringAsFixed(2)}",
              Colors.white70,
            ),
          ] else
            _totalRow(
              "IGST ($gstPercentage%)",
              "₹${taxAmount.toStringAsFixed(2)}",
              Colors.white70,
            ),
          const Divider(color: Colors.white24, height: 20),
          _totalRow(
            "Grand Total",
            "₹${totalAmount.toStringAsFixed(2)}",
            Colors.white,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        _buildTextField("Terms & Conditions", termsController, maxLines: 2),
        const SizedBox(height: 12),
        _buildTextField("Notes / Remarks", notesController, maxLines: 1),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Payable",
                  style: TextStyle(color: slate500, fontSize: 12),
                ),
                Text(
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              if (items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please add at least one item")),
                );
                return;
              }
              PdfService.generateInvoice(
                client: widget.client,
                items: items,
                invoiceNo: invoiceNumber,
                isInterState: isInterState,
                gstPercent: gstPercentage,
                terms: termsController.text,
                notes: notesController.text,
              );
            },
            child: const Text(
              "GENERATE INVOICE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
