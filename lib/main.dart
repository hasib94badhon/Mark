import 'package:flutter/material.dart';
import 'package:namer_app/pages/Homepage.dart';
import 'package:namer_app/pages/cartPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "/":(context)=> HomePage(),
        "cartPage":(context) => cartPage(),

      },
    );
  }
}

