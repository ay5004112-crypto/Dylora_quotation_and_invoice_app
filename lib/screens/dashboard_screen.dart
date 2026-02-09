import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/stat_card.dart';
void main(){
  runApp(MaterialApp(home:DashboardScreen(),),);
}
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Dashboard Overview",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: const [
                      StatCard(value: "0", title: "Total Invoices", color: Colors.blueGrey),
                      SizedBox(width: 20),
                      StatCard(value: "\Rs.0.00", title: "Total Revenue", color: Colors.blueGrey),
                      SizedBox(width: 20),
                      StatCard(value: "0", title: "Paid", color: Colors.green),
                      SizedBox(width: 20),
                      StatCard(value: "0", title: "Pending", color: Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Recent Invoices",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 220,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.description_outlined, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text("No invoices yet"),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text("Create Invoice"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
