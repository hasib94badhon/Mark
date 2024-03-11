import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/pages/Homepage.dart';
import 'package:namer_app/pages/cartPage.dart';
import 'package:namer_app/screens/favorite_screen.dart';
import 'package:namer_app/screens/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

int pageIndex=0;

  List<Widget> pages = [
    HomePage(),
    cartPage(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: (){},
          child: Icon(
            Icons.qr_code,
            size: 20,
            ),
            backgroundColor: Color(0xFFDB3022),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          CupertinoIcons.home,
          CupertinoIcons.dial,
          CupertinoIcons.chart_bar,
          CupertinoIcons.profile_circled,
        ],
        //splashColor: ,
        inactiveColor: Colors.black.withOpacity(0.5),
        activeColor: Colors.red,
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        elevation: 0,
        onTap: (index){
          setState(() {
            pageIndex=index;
          });
        },
      ),
    );
  }
}
