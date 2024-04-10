import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/forgot_screen.dart';
import 'package:aaram_bd/screens/login_screen.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/otp_screen.dart';
import 'package:aaram_bd/screens/recovery_screen.dart';
import 'package:aaram_bd/screens/signup_screen.dart';
import 'package:aaram_bd/screens/splash_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/test_data_post_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "/":(context)=> (SplashScreen()),
      },
    );
  }
}

