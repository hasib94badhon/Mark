import 'package:flutter/material.dart';
import 'package:namer_app/pages/Centerpage.dart';
import 'package:namer_app/pages/Homepage.dart';
import 'package:namer_app/screens/SignUp_screen.dart';
import 'package:namer_app/screens/forgot_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child:TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=>ForgotScreen(),
                          )
                      );
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ),

                SizedBox(height: 28,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CenterPage(),
                        ));
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

                SizedBox(height: 20 ,),
                Text("OR"),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87,fontSize: 15)),
                  TextButton(onPressed: () {  
                  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            ));
                  }, child: Text("Sign Up",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.blue.shade800),)),

                ],)
              ],
            ),
          )
        ],
      ))),
    );
  }
}
