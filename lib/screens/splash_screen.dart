import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Onboarding(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("images/banner1.jpg"),
              fit: BoxFit.cover,
              opacity: 0.9,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('In search for everything you need',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
              ),
              Text('PoweredBy @ AaramBD',
                  style: TextStyle(
                    color: Color(0xFF5866E6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
              ),
            ],
            
          )),
    );
  }
}
