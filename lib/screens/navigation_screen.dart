import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/ShopsCart.dart';
import 'package:aaram_bd/screens/user_profile.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    CartPage(),
    ServiceCart(),
    ShopsCart(),
    UserProfile (),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 80,
        activeColor: Colors.redAccent,
        inactiveColor: Colors.black,
        iconSize: 30,
        icons: [
          CupertinoIcons.home,
          CupertinoIcons.chart_bar_circle,
          CupertinoIcons.info_circle_fill,
          CupertinoIcons.profile_circled,
        ],
        activeIndex: pageIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        elevation: 8,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
