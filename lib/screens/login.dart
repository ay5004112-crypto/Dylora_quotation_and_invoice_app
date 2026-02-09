import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final userController = TextEditingController();
  bool passToggle =true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical:60),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/avatar.jpeg',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 50,),
                TextFormField(
                  controller: userController,
                  keyboardType: TextInputType.name,
                  //controller
                  decoration: InputDecoration(
                    labelText: "user name",
                    border:OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter user name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  //controller
                  decoration: InputDecoration(
                    labelText: "Email",
                    border:OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),                    
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Email";
                    }
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                      if(!emailValid){
                        return "Enter valid Email";
                      }
                    return null;
                  },
                ),
                  SizedBox(height:20),
                  TextFormField(
                  controller: passController,
                  keyboardType: TextInputType.name,
                  obscureText: passToggle,
                  //controller
                  decoration: InputDecoration(
                    labelText: "Password",
                    border:OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: (){
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Paasword";
                    }
                    else if(passController.text.length<6){
                      return "Password length should not be less than 6";
                    }
                    return null;
                  }
                  ),
                  SizedBox(height:40),
                  InkWell(
                    onTap:(){
                      if(_formfield.currentState!.validate()){
                      print("success");
                      emailController.clear();
                      passController.clear();
                      }
                    },
                    child: Column(
                      children: [
                        ElevatedButton(onPressed: () {
                          if (_formfield.currentState!.validate()) {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DashboardScreen(),
                            ),
                            );
                          }
                        },
                        child: Text("LOGIN"),
                        )

                      ],
                    ),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text ("Already have an account?",style: TextStyle(fontSize: 16),),
                  TextButton(onPressed: (){},
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}



