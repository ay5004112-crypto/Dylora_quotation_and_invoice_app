import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          // Sidebar
          Container(
            width: 90,
            color: Color(0xff1f2937),
            child: Column(
              children: [
                SizedBox(height: 40),
                Icon(Icons.receipt_long, color: Colors.white,),
                SizedBox(height: 30),
                Icon(Icons.dashboard, color: Colors.white70),
                SizedBox(height: 30),
                Icon(Icons.add_circle_outline, color: Colors.white70),
                SizedBox(height: 30),
                Icon(Icons.description, color: Colors.white70),
                Spacer(),
                Icon(Icons.settings, color: Colors.white70),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Dashboard Overview",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  // Cards Row
                  Row(
                    children: [
                      dashboardCard("0", "Total Invoices", Colors.blueGrey),
                      SizedBox(width: 20),
                      dashboardCard("\$0.00", "Total Revenue", Colors.blueGrey),
                      SizedBox(width: 20),
                      dashboardCard("0", "Paid", Colors.green),
                      SizedBox(width: 20),
                      dashboardCard("0", "Pending", Colors.orange),
                    ],
                  ),

                  SizedBox(height: 40),

                  Text(
                    "Recent Invoices",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  // Empty Invoice Box
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No invoices yet"),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text("Create Invoice"),
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

  Widget dashboardCard(String value, String title, Color color) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.white70))
          ],
        ),
      ),
    );
  }
}
