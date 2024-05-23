import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int phone;
  
  final int service_id;
  final int shop_id;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.phone,
    
    required this.service_id,
    required this.shop_id
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      business_name: json['business_name'] ?? '',
      phone: json['phone'] ?? 0,
      service_id: json['service_id'] ?? 0,
      shop_id: json['shop_id'] ?? 0
      
    );
  }
}






class AdvertScreen extends StatefulWidget {
  final String userId;
  final bool isService;
  AdvertScreen({required this.userId,required this.isService});
  
  @override
  State<AdvertScreen> createState() => _AdvertScreenState();

 
}

class TimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  TimelineWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(3),
      height: 260, // Fixed height to show a part of the timeline
      child: ListView.builder(
        itemCount: posts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var post = posts[index];
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      post['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['businessName'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(post['category']),
                      SizedBox(height: 5),
                      Text(post['location']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AdvertScreenState extends State<AdvertScreen> {

  late Future<List<UserDetail>> data;

   @override 
  void initState() {
    super.initState();
    data = fetchUserDetails(widget.userId, widget.isService);
  }

  Future<List<UserDetail>> fetchUserDetails(String id, bool isService) async {
    final String idParam = isService ? 'service_id=$id' : 'shop_id=$id';
    final String url = 'http://192.168.0.103:5000/get_service_or_shop_data?$idParam';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final dataKey = isService ? 'service_data' : 'shop_data';
        final userDetails = jsonResponse[dataKey] != null
            ? (jsonResponse[dataKey] as List)
                .map((data) => UserDetail.fromJson(data))
                .toList()
            : <UserDetail>[];

        return userDetails;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // ////////////////////////////////////////////




  int pageIndex = 0;

  List<String> images = [
    "images/image1.png",
    "images/image2.png",
    "images/image3.png",
    "images/image4.png",
    "images/image5.png"
  ];

  List<Widget> pages = [
    CartPage(),
    CartPage(),
    CartPage(),
    UserProfile(),
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
        backgroundColor: Colors.blue[100],
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
      body: FutureBuilder<List<UserDetail>>(
        future: data,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final users = snapshot.data!;
              if (users.isEmpty)
              {
                return Center(child: Text("No data available"),);
              }
             
              
              return 
              SingleChildScrollView(
                

       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sliding Picture Show
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                
                  SizedBox(
                    height: 220,
                    child: FanCarouselImageSlider(
                      sliderHeight: 200,
                      autoPlay: true,
                      imagesLink: images,
                      isAssets: true,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              users.isNotEmpty ? users[0].address : 'Unknown',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    users[0].business_name , // Placeholder for the electrician's name
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                     users[0].category ,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 3.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print("Rating is $rating");
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.green,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Colors.blue,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.comment,
                          color: Colors.orange,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.facebook,
                          color: Colors.blue[800],
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.south_america_sharp,
                            color: Colors.green[800]),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // After Review and Comments Row and before Gallery Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Give Review
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                        ),
                        child: Text("Review",
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Comments
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                        ),
                        child: Text("Comments",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TimelineWidget(
                    posts: List.generate(
                        6,
                        (index) => {
                              "businessName": "Business $index",
                              "category": "Category $index",
                              "location": "Location $index",
                              "image": "images/image${index % 5 + 1}.png",
                            }),
                  ),
// Continue with Gallery section
                ],
              ),
            ),

            // Gallery
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle Upload and Post button pressed
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          "Upload and Post",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite_border,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "100",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "50",
                                            style: TextStyle(
                                              color: Colors.black,
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
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "2 hours ago",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
              
            }
          }
          return Center(child: CircularProgressIndicator());
        }
        
        
  
          
      ),
      
      
      
      
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   overlayColor: Colors.black,
      //   overlayOpacity: 0.5,
      //   elevation: 6.0,
      //   children: [
      //     SpeedDialChild(
      //       child: Icon(Icons.info, size: 24, color: Colors.white),
      //       backgroundColor: Colors.blue,
      //       label: 'Info',
      //       onTap: () {
      //         // Handle Info option tapped
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.local_activity, size: 24, color: Colors.white),
      //       backgroundColor: Colors.green,
      //       label: 'Service',
      //       onTap: () {
      //         // Handle Service option tapped
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.shopping_cart, size: 24, color: Colors.white),
      //       backgroundColor: Colors.orange,
      //       label: 'Shops',
      //       onTap: () {
      //         // Handle Shops option tapped
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.person, size: 24, color: Colors.white),
      //       backgroundColor: Colors.red,
      //       label: 'My Profile',
      //       onTap: () {
      //         // Handle My Profile option tapped
      //       },

      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.person, size: 24, color: Colors.white),
      //       backgroundColor: Colors.red,
      //       label: '',
      //       onTap: () {
      //         // Handle My Profile option tapped
      //       },

      //     ),
      //   ],
      // ),
  
    );
  }
}
