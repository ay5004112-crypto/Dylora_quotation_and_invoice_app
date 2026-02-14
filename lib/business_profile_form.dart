import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Needed for web check
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quotation_invoice/models/business_profile.dart';

class BusinessProfileFormPage extends StatefulWidget {
  final BusinessProfile? profile;
  const BusinessProfileFormPage({super.key, this.profile});

  @override
  State<BusinessProfileFormPage> createState() => _BusinessProfileFormPageState();
}

class _BusinessProfileFormPageState extends State<BusinessProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController name, address, email, phone, gst;
  late TextEditingController accountName, accountNumber, ifsc, bankName;
  String? logoPath, qrPath, stampPath, signaturePath;

  @override
  void initState() {
    super.initState();
    // Pre-filling controllers
    name = TextEditingController(text: widget.profile?.name ?? "");
    address = TextEditingController(text: widget.profile?.address ?? "");
    email = TextEditingController(text: widget.profile?.email ?? "");
    phone = TextEditingController(text: widget.profile?.phone ?? "");
    gst = TextEditingController(text: widget.profile?.gst ?? "");
    accountName = TextEditingController(text: widget.profile?.accountName ?? "");
    accountNumber = TextEditingController(text: widget.profile?.accountNumber ?? "");
    ifsc = TextEditingController(text: widget.profile?.ifsc ?? "");
    bankName = TextEditingController(text: widget.profile?.bankName ?? "");

    logoPath = widget.profile?.logoPath;
    qrPath = widget.profile?.qrPath;
    stampPath = widget.profile?.stampPath;
    signaturePath = widget.profile?.signaturePath;
  }


  // Helper to build the image preview based on platform
  Widget _imagePreview(String path) {
    if (kIsWeb) {
      return Image.network(path, fit: BoxFit.cover, width: double.infinity);
    } else {
      return Image.file(File(path), fit: BoxFit.cover, width: double.infinity);
    }
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        if (type == 'logo') logoPath = image.path;
        if (type == 'qr') qrPath = image.path;
        if (type == 'stamp') stampPath = image.path;
        if (type == 'sign') signaturePath = image.path;
      });
    }
  }

  // Custom styling for inputs
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Business Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader("General Information", Icons.info_outline),
            TextFormField(controller: name, decoration: _inputStyle("Business Name", Icons.business)),
            const SizedBox(height: 16),
            TextFormField(controller: address, maxLines: 2, decoration: _inputStyle("Office Address", Icons.location_on_outlined)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextFormField(controller: email, decoration: _inputStyle("Email", Icons.email))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: phone, decoration: _inputStyle("Phone", Icons.phone))),
            ]),
            const SizedBox(height: 16),
            TextFormField(controller: gst, decoration: _inputStyle("GST / Tax ID", Icons.verified_user_outlined)),

            // UPLOAD SECTION MOVED HERE
            _buildSectionHeader("Company Assets & Branding", Icons.brush_outlined),
            Row(children: [
              _buildImageCard("Logo", logoPath, () => _pickImage('logo')),
              _buildImageCard("UPI QR", qrPath, () => _pickImage('qr')),
            ]),
            Row(children: [
              _buildImageCard("E-Stamp", stampPath, () => _pickImage('stamp')),
              _buildImageCard("Signature", signaturePath, () => _pickImage('sign')),
            ]),

            _buildSectionHeader("Banking Details", Icons.account_balance_outlined),
            TextFormField(controller: bankName, decoration: _inputStyle("Bank Name", Icons.account_balance)),
            const SizedBox(height: 16),
            TextFormField(controller: accountNumber, decoration: _inputStyle("Account Number", Icons.numbers)),
            const SizedBox(height: 16),
            TextFormField(controller: ifsc, decoration: _inputStyle("IFSC Code", Icons.password)),

            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, BusinessProfile(
                    name: name.text, address: address.text, email: email.text,
                    phone: phone.text, gst: gst.text, accountName: accountName.text,
                    accountNumber: accountNumber.text, ifsc: ifsc.text, bankName: bankName.text,
                    logoPath: logoPath, qrPath: qrPath, stampPath: stampPath, signaturePath: signaturePath,
                  ));
                }
              },
              child: const Text("SAVE PROFILE", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1)),
      ]),
    );
  }

  Widget _buildImageCard(String label, String? path, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 110,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: path == null
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent),
                  Text(label, style: const TextStyle(fontSize: 12))
                ])
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _imagePreview(path),
                ),
        ),
      ),
    );
  }
}
