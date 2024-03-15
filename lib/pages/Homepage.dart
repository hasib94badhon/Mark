
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:namer_app/widgets/CartAppBar.dart';
import 'package:namer_app/widgets/CartBottomNavbar.dart';
import 'package:namer_app/widgets/CartItemSamples.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(),

          Container(
            //temporary height
            height: 1000,
            padding: EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
              CartItemsSamples(),
              Container(
                //
                //
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFF4C53A5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                     Icons.add,
                     color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Add Coupon Here',
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),)
                ],),
              ),
            ],
            ),
          )
        ],
      ),
    );
  }
}