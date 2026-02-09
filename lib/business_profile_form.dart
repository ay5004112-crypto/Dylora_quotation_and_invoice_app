import 'package:flutter/material.dart';
import '../models/business_profile.dart';

class BusinessProfileFormPage extends StatefulWidget {
  const BusinessProfileFormPage({super.key});

  @override
  State<BusinessProfileFormPage> createState() => _BusinessProfileFormPageState();
}

class _BusinessProfileFormPageState extends State<BusinessProfileFormPage> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final gst = TextEditingController();

  final accountName = TextEditingController();
  final accountNumber = TextEditingController();
  final ifsc = TextEditingController();
  final bankName = TextEditingController();

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        BusinessProfile(
          name: name.text,
          address: address.text,
          email: email.text,
          phone: phone.text,
          gst: gst.text,
          accountName: accountName.text,
          accountNumber: accountNumber.text,
          ifsc: ifsc.text,
          bankName: bankName.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Business Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Business Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: "Business Name"),
                validator: (v) => v!.isEmpty ? "Enter business name" : null,
              ),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextFormField(
                controller: gst,
                decoration: const InputDecoration(labelText: "GST Number"),
              ),
              const SizedBox(height: 20),
              const Text("Bank Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: accountName,
                decoration:
                    const InputDecoration(labelText: "Account Holder Name"),
              ),
              TextFormField(
                controller: accountNumber,
                decoration:
                    const InputDecoration(labelText: "Account Number"),
              ),
              TextFormField(
                controller: ifsc,
                decoration: const InputDecoration(labelText: "IFSC Code"),
              ),
              TextFormField(
                controller: bankName,
                decoration: const InputDecoration(labelText: "Bank Name"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Save Business Profile"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
