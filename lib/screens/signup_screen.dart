import 'package:flutter/material.dart';
import 'package:namer_app/screens/SignUp_screen.dart';
import 'package:namer_app/screens/login_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> addDataToDB() async {
    final String apiUrl = 'http://127.0.0.1:5000/add';

    final Map<String, dynamic> requestData = {
      'phone': _phoneController.text,
      'password': _passwordController.text,
    };
     
     // Convert the data to raw JSON format
    String jsonData = jsonEncode(requestData);
    print('Raw JSON Data: $jsonData');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8' ,// Set the Content-Type to 'application/json'
        
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Data added successfully');
    } else {
      print('Failed to add data: ${response.body}');
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
          Image.asset(
            'images/call1.png',
            height: 150,
          ),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Name',
                //     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                //     prefixIcon: Icon(Icons.person),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Enter Email',
                //     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                //     prefixIcon: Icon(Icons.email),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
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
                  height: 10,
                ),
                // TextFormField(
                //   controller: _passwordController,
                //   obscureText: true,
                //   decoration: InputDecoration(
                //     labelText: 'Confirm Password',
                //     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                //     prefixIcon: Icon(Icons.lock),
                //     suffixIcon: Icon(Icons.remove_red_eye),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    addDataToDB();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(60),
                      backgroundColor: Color.fromARGB(255, 30, 224, 208),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),

                SizedBox(
                  height: 28,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 18)),
                    TextButton(
                        onPressed: () {
                          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text(
                          "Login",
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


void main() {
  runApp(SignUpScreen());
}
  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }

