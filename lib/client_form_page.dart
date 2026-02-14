import 'package:flutter/material.dart';
import '../models/client_model.dart';

class ClientFormPage extends StatefulWidget {
  final Client? client;
  const ClientFormPage({super.key, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name, address, email, phone, gst;

  // Modern Indigo & Custom Slate palette
  final Color primaryColor = const Color(0xff6366f1); 
  final Color secondaryColor = const Color(0xff4338ca);
  final Color backgroundColor = const Color(0xfff8fafc);
  final Color slate500 = const Color(0xff64748b);
  final Color slate100 = const Color(0xfff1f5f9);

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.client?.name ?? "");
    address = TextEditingController(text: widget.client?.address ?? "");
    email = TextEditingController(text: widget.client?.email ?? "");
    phone = TextEditingController(text: widget.client?.phone ?? "");
    gst = TextEditingController(text: widget.client?.gstNumber ?? "");
  }

  @override
  void dispose() {
    name.dispose(); address.dispose(); email.dispose();
    phone.dispose(); gst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.client != null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEditing ? "Update Client" : "New Client",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("COMPANY INFORMATION"),
                const SizedBox(height: 16),
                _buildFormCard(),
                const SizedBox(height: 32),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: slate500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTextField(
            controller: name,
            label: "Client / Company Name",
            icon: Icons.business_rounded,
            validator: (v) => v!.isEmpty ? "Please enter a name" : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: email,
            label: "Email Address",
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: phone,
            label: "Phone Number",
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: address,
            label: "Full Address",
            icon: Icons.location_on_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: gst,
            label: "GST Number",
            icon: Icons.assignment_rounded,
            isOptional: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isOptional = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: isOptional ? "$label (Optional)" : label,
        labelStyle: TextStyle(color: slate500, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryColor, size: 22),
        filled: true,
        fillColor: const Color(0xfff8fafc),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: slate100, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(
              context,
              Client(
                name: name.text.trim(),
                address: address.text.trim(),
                email: email.text.trim(),
                phone: phone.text.trim(),
                gstNumber: gst.text.trim(),
              ),
            );
          }
        },
        child: const Text(
          "SAVE DETAILS",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }
}