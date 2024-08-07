import 'dart:ui';

import 'package:aaram_bd/widgets/AppDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/pages/ShopsCart.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  final String userPhone;

  NavigationScreen({required this.userPhone});

  @override
  State<NavigationScreen> createState() =>
      _NavigationScreenState(userPhone: userPhone);
}

class _NavigationScreenState extends State<NavigationScreen> {
  final String userPhone;
  _NavigationScreenState({required this.userPhone});

  int pageIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      CartPage(
        userPhone: userPhone,
      ),
      ServiceCart(), // Assuming this screen doesn't need the phone number
      ShopsCart(), // Assuming this screen doesn't need the phone number
      UserProfile(userPhone: userPhone),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        titleSpacing: 2,
        title: Row(
          children: [
            Text(
              'AaramBD',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            // Spacer to push the logout icon to the right
            // Logout Icon
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Handle Logout button press
              },
            ),
          ],
        ),
      ),
      drawer: AppDrawer(
        userPhone: userPhone,
      ),
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
