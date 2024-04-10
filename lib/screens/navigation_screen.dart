import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Centerpage.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/advert_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    FavoriteScreen(),
    cartPage(),
    Homepage(),
    AdvertScreen(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CenterPage()),
            );
          },
          child: Icon(
            Icons.qr_code,
            size: 20,
          ),
          backgroundColor: Colors.white,
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
        activeColor: Colors.blue.shade800,
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        elevation: 0,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
