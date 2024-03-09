import 'package:flutter/material.dart';
import 'package:namer_app/pages/Homepage.dart';
import 'package:namer_app/pages/cartPage.dart';
import 'package:namer_app/screens/forgot_screen.dart';
import 'package:namer_app/screens/login_screen.dart';
import 'package:namer_app/screens/recovery_screen.dart';
import 'package:namer_app/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "/":(context)=> RecoveryScreen(),
        "cartPage":(context) => cartPage(),

      },
    );
  }
}

