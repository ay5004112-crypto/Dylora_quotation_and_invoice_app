import 'package:flutter/material.dart';
import 'package:quotation_invoice/models/business_profile.dart';
import 'package:quotation_invoice/client_list.dart';
// Ensure this import exists to recognize the Client type
import 'client_model.dart'; 

class InvoicePage extends StatefulWidget {
  final BusinessProfile business;

  const InvoicePage({
    super.key,
    required this.business,
  });

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    clientNameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _selectClient() async {
    final selected = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const ClientListPage()),
    );

    // FIXED: Added type check to allow access to .name
    if (selected != null && selected is Client) {
      setState(() {
        clientNameController.text = selected.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = widget.business; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Invoice"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Business Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text("Company: ${business.name}", style: const TextStyle(fontSize: 16)),
            Text("Phone: ${business.phone}"),
            if (business.email.isNotEmpty) Text("Email: ${business.email}"),
            if (business.gst.isNotEmpty) Text("GST: ${business.gst}"),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Client Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // NEW: Button to select from saved clients
                TextButton.icon(
                  onPressed: _selectClient,
                  icon: const Icon(Icons.person_add),
                  label: const Text("Select Saved"),
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: clientNameController,
              decoration: const InputDecoration(
                labelText: "Client/Company Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (clientNameController.text.isEmpty || amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill required fields")),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invoice Generated Successfully")),
                );
              },
              child: const Text("Generate Invoice"),
            )
          ],
        ),
      ),
    );
  }
}