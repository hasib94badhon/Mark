import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    CartPage(),
    CartPage(),
    CartPage(),
    UserProfile(),
  ];



  List<String> imageList = [
    "images/image1.png",
    "images/image2.png",
    "images/image3.png",
    "images/image4.png",
    "images/image5.png",
  ];

  List<String> productTitles = [
    "Electrician",
    "Plumber",
    "Carpenter",
    "Photographer",
    "Lo-let",
  ];

  List<String> prices = [
    "\$300",
    "\$300",
    "\$300",
    "\$300",
    "\$300",
  ];

  List<String> reviews = [
    "54",
    "504",
    "54",
    "554",
    "54",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contex) => NavigationScreen(),
              ),
            );
          },
        ),
        title: Text('Favorite Screen'),
      ),
      body:

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Button
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Find your service',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sliding Show
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: imageList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imageList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: productTitles.length,
              itemBuilder: (context, index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()),);
                            },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Image.asset(
                              imageList[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productTitles[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber),
                                    Text(reviews[index]),
                                    SizedBox(width: 10),
                                    Text(
                                      prices[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
          SpeedDialChild(
            child: Icon(Icons.person, size: 24, color: Colors.white),
            backgroundColor: Colors.red,
            label: '',
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen()),);
          });
        },
      ),
    );
  }
}
