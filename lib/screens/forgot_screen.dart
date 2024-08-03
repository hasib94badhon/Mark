<<<<<<< HEAD
=======

>>>>>>> origin/main
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aaram_bd/screens/otp_screen.dart';
import 'package:aaram_bd/screens/recovery_screen.dart';
import 'package:aaram_bd/screens/signup_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
<<<<<<< HEAD
  bool clrButton = false;

  TextEditingController emailController = TextEditingController();
=======

  bool clrButton = false;

TextEditingController emailController = TextEditingController();

>>>>>>> origin/main

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
=======
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
>>>>>>> origin/main
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
<<<<<<< HEAD
              SizedBox(
                height: 10,
              ),
              Text(
                "Forgot Password",
=======
              SizedBox(height: 10,),
              Text("Forgot Password",
>>>>>>> origin/main
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
<<<<<<< HEAD
              SizedBox(
                height: 50,
              ),
=======
              SizedBox(height: 50,),
>>>>>>> origin/main
              Text(
                "Please enter your email address. You will receive a link to create or set a new password via email.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
<<<<<<< HEAD
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: emailController,
                  onChanged: (val) {
                    if (val != "") {
                      setState(() {
                        clrButton = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            emailController.clear();
                          });
                        },
                        child: Icon(
                          CupertinoIcons.multiply,
                          color: Color(0xFFDB3022),
                        ),
                      ))),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecoveryScreen(),
                      ));
                },
                child: Text(
                  "Send Code",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text("OR"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(),
                          ));
                    },
                    child: Text(
=======
              SizedBox(height: 20,),
              TextFormField(
                  controller: emailController,
                  onChanged: (val){
                      if(val !=""){
                        setState(() {
                          clrButton = true;
                        });
                      }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          emailController.clear();
                        });
                      },
                        child: Icon(
                          CupertinoIcons.multiply,
                          color: Color(0xFFDB3022),
                          ),
                    )
                  )
              ),
              SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecoveryScreen(),
                        ));
                  },
                  child: Text(
                    "Send Code",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text("OR"),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=>OTPScreen(),
                          ));
                    },
                     child: Text(
>>>>>>> origin/main
                      "Verify Using Number",
                      style: TextStyle(
                        color: Color(0xFFDB3022),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
<<<<<<< HEAD
                    ),
                  )
                ],
              ),
=======
                     ),
                    )
                  ],
                ),
>>>>>>> origin/main
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/main
