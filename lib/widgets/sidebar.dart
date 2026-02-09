import 'package:flutter/material.dart';
import '../business_profile_list.dart';
import 'package:quotation_invoice/client_list.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: const Color(0xff1f2937),
      child: Column(
        children:  [
          SizedBox(height: 40),
          Icon(Icons.person, color: Colors.white),
          Text("user",style: TextStyle(color: Colors.white),),
          SizedBox(height: 30),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessProfileListPage()),);
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Icon(Icons.business, color: Colors.white),
                  Text("company profile",style: TextStyle(color: Colors.white),),
                  ],
                  ),
            ),
          ),
          //Icon(Icons.business, color: Colors.white),
          //Text("company profile",style: TextStyle(color: Colors.white),),
          SizedBox(height: 30),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap:(){
              Navigator.push(context,MaterialPageRoute(builder: (context) => ClientListPage(),));
            },
            child: Padding(padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white70),
                Text("client details",style: TextStyle(color: Colors.white),),                
              ],
            ),
          ),
          ),
          //Icon(Icons.add_circle_outline, color: Colors.white70),
          //Text("client details",style: TextStyle(color: Colors.white),),
          SizedBox(height: 30),
          Icon(Icons.description, color: Colors.white70),
          Text("invoice",style: TextStyle(color: Colors.white),),
          Spacer(),
          Icon(Icons.settings, color: Colors.white70),
          Text("settings",style: TextStyle(color: Colors.white),),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
