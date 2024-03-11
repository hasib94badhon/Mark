import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoriteScreen extends StatelessWidget {
  // Non-const constructor

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 50,
                    width: MediaQuery.of(context).size.width/1.5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ], // Added this closing bracket
          ),
        ),
      ),
    );
  }
}
