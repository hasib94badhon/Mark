import 'package:flutter/material.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:http/http.dart' as http;
class FavoriteScreen extends StatefulWidget {
  
  
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  
  List<String> tabs = ["All", "Category", "Top", "Recommended"];

  List imageList = [
    "images/image1.png",
    "images/image2.png",
    "images/image3.png",
    "images/image4.png",
    "images/image5.png",
  ];

  List productTitles = [
    "Electrician",
    "Plumber",
    "Carpenter",
    "Photographer",
    "Lo-let",
  ];

  List prices = [
    "\$300",
    "\$300",
    "\$300",
    "\$300",
    "\$300",
  ];

  List reviews = [
    "54",
    "504",
    "54",
    "554",
    "54",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue.shade800,
                          ),
                          border: InputBorder.none,
                          label: Text(
                            "Find your service",
                            style: TextStyle(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 6,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF0DD),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 2,
                          ),
                        ],
                  ),
                  child: Image.asset("images/AaramBD_logo.jpg",
                  fit: BoxFit.cover,),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      return FittedBox(
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.only(left: 05, right: 05),
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 1000,
                  child: ListView.builder(
                    itemCount: imageList.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            //color: Colors.amber,
                            width: 300,
                            margin: EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            imageList[index],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 150,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productTitles[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 22,
                                          ),
                                          Text(
                                            '(' + reviews[index] + ')',
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            prices[index],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
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
                          SizedBox(height: 20),
                          Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.only(left: 05, right: 05),
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                          SizedBox(height: 20),

                          Container(
                            //color: Colors.amber,
                            width: 300,
                            margin: EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            imageList[index],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 150,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productTitles[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 22,
                                          ),
                                          Text(
                                            '(' + reviews[index] + ')',
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            prices[index],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
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
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
