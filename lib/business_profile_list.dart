import 'package:flutter/material.dart';
import '../models/business_profile.dart';
import 'business_profile_form.dart';
import 'invoice_Page.dart';

class BusinessProfileListPage extends StatefulWidget {
  const BusinessProfileListPage({super.key});

  @override
  State<BusinessProfileListPage> createState() =>
      _BusinessProfileListPageState();
}

class _BusinessProfileListPageState extends State<BusinessProfileListPage> {
  List<BusinessProfile> profiles = [];
  BusinessProfile? selectedProfile;

  Future<void> addProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BusinessProfileFormPage(),
      ),
    );

    if (result != null) {
      setState(() {
        profiles.add(result);
      });
    }
  }

  void goToInvoice() {
    if (selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a business profile")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicePage(
          business: selectedProfile!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Profiles"),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: addProfile,
              ),
              const Text(
                "Add Profile",
                style: TextStyle(color: Colors.black,),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: profiles.isEmpty
                ? const Center(child: Text("No business profiles added"))
                : ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final p = profiles[index];
                      return Card(
                        color: selectedProfile == p
                            ? Colors.blue.shade100
                            : null,
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text(p.phone),
                          trailing: selectedProfile == p
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedProfile = p;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: selectedProfile == null ? null : goToInvoice,
              child: const Text("Generate Invoice"),
            ),
          )
        ],
      ),
    );
  }
}
