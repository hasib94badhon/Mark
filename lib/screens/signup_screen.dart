import 'package:flutter/material.dart';
import 'package:namer_app/screens/SignUp_screen.dart';
import 'package:namer_app/screens/login_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter POST Request Example',
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final apiUrl = "http://127.0.0.1:5000/add";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> sendPostRequest() async {
    var response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneController.text,
          "password": passwordController.text,
          "userId": 1,
        }));

    if (response.statusCode == 201) {
      print("Data Added");
      // ignore: use_build_context_synchronously
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Post created successfully!"),
      // ));
    } else {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Failed to create post!"),
      // ));
      print("Failed to add data");
    }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
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
                  controller: phoneController,
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
                  controller: passwordController,
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
                          sendPostRequest();
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

