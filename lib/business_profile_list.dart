import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/business_profile.dart';
import 'business_profile_form.dart';
import 'invoice_Page.dart'; 

class BusinessProfileListPage extends StatefulWidget {
  const BusinessProfileListPage({super.key});

  @override
  State<BusinessProfileListPage> createState() => _BusinessProfileListPageState();
}

class _BusinessProfileListPageState extends State<BusinessProfileListPage> {
  List<BusinessProfile> profiles = [];
  BusinessProfile? selectedProfile;

  // Handles adding or editing profiles
  Future<void> navigateToForm({BusinessProfile? profileToEdit, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BusinessProfileFormPage(profile: profileToEdit),
      ),
    );

    if (result != null && result is BusinessProfile) {
      setState(() {
        if (index != null) {
          profiles[index] = result;
          // Sync selected profile if it was edited
          if (selectedProfile == profileToEdit) {
            selectedProfile = result;
          }
        } else {
          profiles.add(result);
        }
      });
    }
  }

  void deleteProfile(int index) {
    setState(() {
      if (selectedProfile == profiles[index]) {
        selectedProfile = null;
      }
      profiles.removeAt(index);
    });
  }

  // FIXED: Web-safe image widget to prevent !kIsWeb crash
  Widget _buildLeadingImage(String? path, bool isSelected) {
    if (path == null || path.isEmpty) {
      return CircleAvatar(
        backgroundColor: isSelected ? Colors.white : Colors.blueAccent,
        child: Icon(Icons.business, color: isSelected ? Colors.blueAccent : Colors.white),
      );
    }

    return CircleAvatar(
      backgroundColor: isSelected ? Colors.white : Colors.blueGrey[100],
      child: ClipOval(
        child: kIsWeb
            ? Image.network(
                path,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              )
            : Image.file(
                File(path),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Select Business", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: profiles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final p = profiles[index];
                final isSelected = selectedProfile == p;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: _buildLeadingImage(p.logoPath, isSelected),
                    title: Text(
                      p.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      p.email,
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    trailing: _buildPopupMenu(p, index, isSelected),
                    onTap: () {
                      setState(() {
                        // Toggle selection
                        selectedProfile = isSelected ? null : p;
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToForm(),
        icon: const Icon(Icons.add,color:Colors.white),
        label: const Text("Add Profile",style:TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_center_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Business Profiles Found", style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 8),
          const Text("Click '+' to create your first profile", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BusinessProfile p, int index, bool isSelected) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: isSelected ? Colors.white : Colors.grey),
      onSelected: (value) {
        if (value == 'edit') navigateToForm(profileToEdit: p, index: index);
        if (value == 'delete') deleteProfile(index);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[300],
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: selectedProfile == null ? 0 : 5,
          ),
          onPressed: selectedProfile == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoicePage(business: selectedProfile!),
                    ),
                  );
                },
          child: const Text(
            "CONTINUE TO INVOICE",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1),
          ),
        ),
      ),
    );
  }
}