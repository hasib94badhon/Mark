import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:aaram_bd/widgets/DashBoardWidget.dart';
import 'package:aaram_bd/widgets/HomeAppBar.dart';
import 'package:aaram_bd/widgets/ItemsWidget.dart';

class CenterPage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          
          height: 320,
          width: 300,
          color: Colors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //Upper pair
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(child: Text("dfgdf")),
                      Container(child: Text("dfgdf")),
                    ],),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(child: Text("dfgdf")),
                      SizedBox(height: 2,),
                      Container(child: Text("dfgdf")),
                    ],),
                  ),
                ],
              ),
              
              //Lower pair
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,  
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(child: Text("dfgdf")),
                      SizedBox(height: 2,),
                      Container(child: Text("dfgdf")),
                    ],),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(child: Text("dfgdf")),
                      SizedBox(height: 2,),
                      Container(child: Text("dfgdf")),
                    ],),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}