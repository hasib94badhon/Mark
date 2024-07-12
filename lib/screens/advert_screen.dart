import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:aaram_bd/widgets/ExpendableText.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetail {
  final String address;
  final String businessName;
  final String category;
  final String description;
  final int phone;
  final String photo;
  final int serviceId;
  final int shopId;

  UserDetail({
    required this.address,
    required this.businessName,
    required this.category,
    required this.description,
    required this.phone,
    required this.photo,
    required this.serviceId,
    required this.shopId,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      address: json['location'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      businessName: json['name'] ?? '',
      phone: json['phone'] ?? 0,
      photo: json['photo'] ?? '',
      serviceId: json['service_id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
    );
  }
}

class AdvertData {
  final String userId;
  final bool isService;
  final Map<String, dynamic> additionalData;

  AdvertData({
    required this.userId,
    required this.isService,
    required this.additionalData,
  });
}

class AdvertScreen extends StatefulWidget {
  final AdvertData advertData;
  final String userId;
  final bool isService;

  AdvertScreen({
    required this.advertData,
    required this.userId,
    required this.isService,
  });

  @override
  _AdvertScreenState createState() => _AdvertScreenState();
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
                Container(
                  height: 140, // Set fixed height for the image container
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      post['image']!,
                      fit: BoxFit
                          .cover, // Cover to ensure it fills the container
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['businessName']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(post['category']!),
                      SizedBox(height: 5),
                      Text(post['location']!),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaramBD'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_search_outlined),
            iconSize: 35,
            onPressed: () {},
          ),
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
            bottomRight: Radius.circular(25),
          ),
        ),
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
                return Center(child: Text("No data available"));
              }

              return Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.09),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                    size: 20,
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
                          // copy from here
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  margin: EdgeInsets.only(
                                      right: 20, top: 15, bottom: 8),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border: Border.all(
                                        width: 3, color: Colors.greenAccent),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Image.network(
                                      "http://aarambd.com/photo/${users[0].photo}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        users[0].businessName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    users[0].category,
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 20,
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
                                  itemSize: 22,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print("Rating is $rating");
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: ExpandableText(
                                    text:
                                        'Electronics stores are the ideal place to shop for all types of consumer electronics, from televisions and sound systems to computers and gaming devices. ',
                                  )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                        icon: Icon(
                                          Icons.south_america_sharp,
                                          color: Colors.green[800],
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle Related items
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Related items",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
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
                                    },
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle Related items
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Scroll Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 10,
                                ),
                                Container(
                                  height: 350,
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 5,
                                        margin: EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    15)),
                                                    child: Image.network(
                                                      'https://example.com/image${index + 1}.jpg',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('Like'),
                                                          Spacer(),
                                                          Icon(
                                                            Icons.comment,
                                                            color: Colors.blue,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('Comment'),
                                                          Spacer(),
                                                          Icon(
                                                            Icons.share,
                                                            color: Colors.green,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('Share'),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.access_time,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('Posted 1h ago'),
                                                          Spacer(),
                                                          Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            size: 20,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text('100 Views'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                              bottom: 70,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                //color: Colors.black12,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35)),
                                                child: Text(
                                                  'Floating Description ${index + 1}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
