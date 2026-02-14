import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login.dart';


class UserProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const UserProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  File? _image;
  bool isEditing = false; // Toggle state for editing mode

  // Controllers to handle text editing
  late TextEditingController userController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the data passed from Login
    userController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Functional Image Picker logic
  Future<void> _pickImage() async {
    if (!isEditing) return; // Only allow picking if in editing mode

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compresses image size
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _navigateToDashboard,
            child: const Text(
              "SKIP",
              style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- FUNCTIONAL PHOTO UPLOAD SECTION ---
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isEditing ? Colors.indigo : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.indigo.shade50,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.person, size: 50, color: Colors.indigo)
                          : null,
                    ),
                  ),
                  if (isEditing) // Only show camera badge when editing
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.indigo,
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isEditing ? "Tap photo to change" : "Your Profile Photo",
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 30),

            // --- EDITABLE FIELDS ---
            _buildEditableField("Username", userController, Icons.person_outline),
            _buildEditableField("Email", emailController, Icons.email_outlined),
            
            // Password tile stays read-only for security
            _infoTile("Password", widget.password.replaceAll(RegExp(r'.'), '*')),

            const SizedBox(height: 40),

            // --- SAVE / CONTINUE BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  if (isEditing) {
                    setState(() => isEditing = false); // Exit editing mode
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Updated!")),
                    );
                  } else {
                    _navigateToDashboard();
                  }
                },
                child: Text(
                  isEditing ? "SAVE CHANGES" : "SAVE & CONTINUE",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- TOGGLE EDIT BUTTON ---
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              icon: Icon(isEditing ? Icons.close : Icons.edit, size: 18),
              label: Text(
                isEditing ? "Discard Changes" : "Edit Details",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                foregroundColor: isEditing ? Colors.red : Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.logout, color: Colors.white),
    label: const Text(
      "LOGOUT",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    ),
    onPressed: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false, // Removes all previous routes
      );
    },
  ),
),

          ],
        ),
      ),
    );
  }

  // Widget for fields that become editable
  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isEditing ? Colors.white : const Color(0xfff8fafc),
        border: Border.all(
          color: isEditing ? Colors.indigo : Colors.grey.shade200,
          width: isEditing ? 1.5 : 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: isEditing, // Toggle interaction
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        decoration: InputDecoration(
          icon: Icon(icon, color: isEditing ? Colors.indigo : Colors.grey),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.normal),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Widget for purely informational tiles
  Widget _infoTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xfff8fafc),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
      ),
    );
  }
}