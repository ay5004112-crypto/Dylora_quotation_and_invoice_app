import 'package:flutter/material.dart';
import '../client_model.dart';
import 'client_form.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  List<Client> clients = [];

  // Add Client
  Future<void> _addClient() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const ClientFormPage()),
    );
    if (result != null) setState(() => clients.add(result));
  }

  // Edit Client
  Future<void> _editClient(Client client, int index) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => ClientFormPage(client: client)),
    );
    if (result != null) setState(() => clients[index] = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Clients"),
        // FIXED: actions is now inside the AppBar parentheses
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addClient,
          ),
          const Center(
            child: Text(
              "Add Client",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: clients.isEmpty
          ? const Center(child: Text("No clients saved yet."))
          : ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final c = clients[index];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.phone),
                  leading: const Icon(Icons.person),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editClient(c, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => clients.removeAt(index)),
                      ),
                    ],
                  ),
                  // Returns the selected client object to the InvoicePage
                  onTap: () => Navigator.pop(context, c), 
                );
              },
            ),
    );
  }
}