import 'package:flutter/material.dart';
import '../models/client_model.dart';
import 'client_form_page.dart';
import "invoice_client_page.dart";


class ClientListPage extends StatefulWidget {
  final Client? initialClient;

  const ClientListPage({super.key,this.initialClient});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  List<Client> clients = [];
  Client? selectedClient;

  final Color primaryColor = const Color(0xff6366f1);
  final Color slate800 = const Color(0xff1e293b);
  final Color slate500 = const Color(0xff64748b);
  final Color slate100 = const Color(0xfff1f5f9);

  Future<void> navigateToForm({Client? clientToEdit, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClientFormPage(client: clientToEdit)),
    );

    if (result != null && result is Client) {
      setState(() {
        if (index != null) {
          clients[index] = result;
          if (selectedClient == clientToEdit) selectedClient = result;
        } else {
          clients.add(result);
        }
      });
    }
  }

  void _deleteClient(int index) {
    setState(() {
      if (selectedClient == clients[index]) selectedClient = null;
      clients.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Client deleted"), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Select Client", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, const Color(0xff4338ca)]),
          ),
        ),
      ),
      body: clients.isEmpty ? _buildEmptyState() : _buildClientList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => navigateToForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 80, color: slate100),
          const SizedBox(height: 16),
          Text("No Clients Yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: slate500)),
        ],
      ),
    );
  }

  Widget _buildClientList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        final isSelected = selectedClient == client;

        return Dismissible(
          key: Key(client.name + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => _deleteClient(index),
          child: InkWell(
            onTap: () => setState(() => selectedClient = client),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? primaryColor : Colors.transparent, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? primaryColor : slate100,
                  child: Text(client.name[0].toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : primaryColor)),
                ),
                title: Text(client.name, style: TextStyle(fontWeight: FontWeight.bold, color: slate800)),
                subtitle: Text(client.email, style: TextStyle(color: slate500)),
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined, color: slate500),
                  onPressed: () => navigateToForm(clientToEdit: client, index: index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: selectedClient == null ? null : () {
          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemSelectionPage(client: selectedClient!),
                        ),
                      );
        },
        child: const Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}