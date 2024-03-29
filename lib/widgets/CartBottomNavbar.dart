import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CartBottomNavbar extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 150,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Total",
              style: TextStyle(
                color: Color(0xFF4C53A5),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              ),
              Text(
                "\$250",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              ],

            ),
            Container(
              //alignment: Alignment.center,
              height: 70,
              //width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0XFF4C53A5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Check Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}