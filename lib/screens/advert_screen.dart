import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:aaram_bd/widgets/ExpendableText.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aaram_bd/widgets/TimelineWidget.dart';

class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int phone;

  final int service_id;
  final int shop_id;

  UserDetail(
      {required this.address,
      required this.business_name,
      required this.category,
      required this.phone,
      required this.service_id,
      required this.shop_id});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
        address: json['address'] ?? '',
        category: json['category'] ?? '',
        business_name: json['business_name'] ?? '',
        phone: json['phone'] ?? 0,
        service_id: json['service_id'] ?? 0,
        shop_id: json['shop_id'] ?? 0);
  }
}

class AdvertScreen extends StatefulWidget {
  final String userId;
  final bool isService;
  AdvertScreen({required this.userId, required this.isService});

  @override
  State<AdvertScreen> createState() => _AdvertScreenState();
}

class TimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  TimelineWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 3),
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
    final String url =
        'http://192.168.0.103:5000/get_service_or_shop_data?$idParam';

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
          iconSize: 40,
          color: Colors.white,
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
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
                if (users.isEmpty) {
                  return Center(
                    child: Text("No data available"),
                  );
                }

                return SingleChildScrollView(
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
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      Expanded(
                                        child: Text(
                                          users.isNotEmpty
                                              ? users[0].address
                                              : 'Unknown',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            padding: EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              users[0].business_name,
                              textAlign: TextAlign
                                  .center, // Placeholder for the electrician's name
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              users[0].category,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          RatingBar.builder(
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 26,
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
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.comment,
                                    color: Colors.orange,
                                    size: 40,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.facebook,
                                    color: Colors.blue[800],
                                    size: 40,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.wechat_sharp,
                                    color: Colors.green[800],
                                    size: 40,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          // After Review and Comments Row and before Gallery Section
                          Divider(
                            color: Colors.black,
                            height: 10,
                          ),
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
                                          borderRadius:
                                              BorderRadius.circular(18.0))),
                                ),
                                child: Text("Related items",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            height: 10,
                          ),

                          TimelineWidget(
                            posts: List.generate(
                                12,
                                (index) => {
                                      "businessName": "Business $index",
                                      "category": "Category $index",
                                      "location": "Location $index",
                                      "image":
                                          "images/image${index % 5 + 1}.png",
                                    }),
                          ),
                          // Continue with Gallery section
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 10,
                      ),

                      // Gallery
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Handle Upload and Post button pressed
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green[600]),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    "Activity",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
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
                                child: Container(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    "Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            height: 10,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 6,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Image.asset(
                                                    images[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: ExpandableText(
                                            text:
                                                "fgnsuhfasdfndicvuhsdbfgalekrjbgadkufvhsdkbnaeklrgaeiovfhuadfnvalekrgtaenrgmadfuvihadfngaerwkj gaedfivuadlcvafgaeirug afdsv",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.black,
                                                    size: 22,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "100",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.comment_rounded,
                                                    color: Colors.black,
                                                    size: 22,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "8",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: Colors.black,
                                                    size: 22,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "50",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
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
                                      margin:
                                          EdgeInsets.only(right: 15, top: 15),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "2 min",
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
                    ],
                  ),
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          }),

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
