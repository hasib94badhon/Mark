import 'dart:convert';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/SignUp_screen.dart';
import 'package:aaram_bd/screens/forgot_screen.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String apiUrl =
        'http://192.168.0.103:5000/login'; // Replace with your API URL

    final Map<String, dynamic> requestData = {
      'phone': _phoneController.text,
      'password': _passwordController.text,
    };
    print(requestData);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successfull')),
      );
      // Login successful
      print('Login successful');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationScreen(),
          ));
      // Navigate to the homepage screen
      // Navigator.pushReplacementNamed(context, '/navigationscrenn');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.center,
          backgroundColor: Colors.transparent,
          content: 
          
          Container(
            //color: Colors.amber,
            width: 350,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60),
                    //color: Colors.green,
                    height: 30,
                    width: 350,
                    child: Text("You have insert wrong phone or password",
                    style: TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text('Failed to login. Please check your credentials.')),
      // );
      // Login failed
      print('Login failed: ${response.body}');
      // Show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/call1.png'),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Enter Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotScreen(),
                            ));
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginUser();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => NavigationScreen(),
                    //     ));
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(60),
                      backgroundColor: Color.fromARGB(255, 30, 224, 208),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("OR"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 15)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ))),
    );
  }
}
