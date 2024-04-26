import 'package:aaram_bd/pages/cartPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:aaram_bd/pages/cartPage.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    CartPage(),
    CartPage(),
    CartPage(),
    AdvertScreen (),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 6.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.info, size: 24, color: Colors.white),
            backgroundColor: Colors.blue,
            label: 'Info',
            onTap: () {
              // Handle Info option tapped
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.local_activity, size: 24, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Service',
            onTap: () {
              // Handle Service option tapped
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.shopping_cart, size: 24, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Shops',
            onTap: () {
              // Handle Shops option tapped
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.person, size: 24, color: Colors.white),
            backgroundColor: Colors.red,
            label: 'My Profile',
            onTap: () {
              // Handle My Profile option tapped
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 80,
        activeColor: Colors.green,
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
