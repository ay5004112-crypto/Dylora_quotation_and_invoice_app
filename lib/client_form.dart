import 'package:flutter/material.dart';
import "../client_model.dart";
import 'package:uuid/uuid.dart'; // Helpful for unique IDs

class ClientFormPage extends StatefulWidget {
  final Client? client; // If null, we are adding; if not, we are editing

  const ClientFormPage({super.key, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController name;
  late TextEditingController address;
  late TextEditingController cityStateCountry;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController gst;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing, otherwise empty
    name = TextEditingController(text: widget.client?.name ?? "");
    address = TextEditingController(text: widget.client?.address ?? "");
    cityStateCountry = TextEditingController(text: widget.client?.cityStateCountry ?? "");
    phone = TextEditingController(text: widget.client?.phone ?? "");
    email = TextEditingController(text: widget.client?.email ?? "");
    gst = TextEditingController(text: widget.client?.gst ?? "");
  }

  void saveClient() {
    if (_formKey.currentState!.validate()) {
      final clientData = Client(
        id: widget.client?.id ?? const Uuid().v4(),
        name: name.text,
        address: address.text,
        cityStateCountry: cityStateCountry.text,
        phone: phone.text,
        email: email.text.isEmpty ? null : email.text,
        gst: gst.text.isEmpty ? null : gst.text,
      );
      Navigator.pop(context, clientData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.client == null ? "Add Client" : "Edit Client")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: "Client Name *"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            TextFormField(controller: address, decoration: const InputDecoration(labelText: "Address")),
            TextFormField(controller: cityStateCountry, decoration: const InputDecoration(labelText: "City / State / Country")),
            TextFormField(
              controller: phone, 
              decoration: const InputDecoration(labelText: "Phone Number *"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            TextFormField(controller: email, decoration: const InputDecoration(labelText: "Email (Optional)")),
            TextFormField(controller: gst, decoration: const InputDecoration(labelText: "GST Number (Optional)")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveClient, child: const Text("Save Client")),
          ],
        ),
      ),
    );
  }
}