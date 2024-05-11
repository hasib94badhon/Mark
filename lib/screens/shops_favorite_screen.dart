import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/shops_homepage.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ShopsFavorite extends StatefulWidget {
  @override
  State<ShopsFavorite> createState() => _ShopsFavoriteState();
}

class _ShopsFavoriteState extends State<ShopsFavorite> {
  int pageIndex = 0;


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
        title: Text(
          'AaramBD',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_search_outlined),
            iconSize: 35,
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          onPressed: () {},
          icon: IconButton(
            icon: Icon(Icons.menu),
            iconSize: 35,
            onPressed: () {},
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Button
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 10,),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: const Color.fromARGB(255, 235, 179, 245)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color.fromARGB(255, 235, 179, 245)),
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
              height: 160,
              child: ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(top: 10,right: 10),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width:2, color:Colors.grey.shade300),
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
            SizedBox(height: 10),
            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: productTitles.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShopsHomepage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Color.fromARGB(255, 235, 179, 245)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 3,color: Colors.greenAccent),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 80,
        activeColor: Colors.purple,
        inactiveColor: Colors.black,
        iconSize: 30,
        icons: [
          CupertinoIcons.back,
          CupertinoIcons.home,
        ],
        activeIndex: pageIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        elevation: 8,
        onTap: (index) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigationScreen()),
            );
          });
        },
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShopsFavorite(),
  ));
}