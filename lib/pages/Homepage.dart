import 'dart:async';
import 'dart:convert';

import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/advert_screen.dart';


class Album {
  final int user_id;
  final int reg_id;
  final String phone;
  final String name;
  final String location;
  final String category;

  const Album({
    required this.user_id,
    required this.reg_id,
    required this.name,
    required this.phone,
    required this.category,
    required this.location,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      user_id: json['user_id'] ?? 0,
      reg_id: json['reg_id'] ?? 0,
      name: json['name'],
      phone: json['phone'],
      category: json['category'],
      location: json['location'],
    );
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.101:5000/get_users_data'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> userData = data['users_data'];

    return userData.map((json) => Album.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  
  List<Widget> pages = [
    CartPage(),
    CartPage(),
    CartPage(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    var pageIndex = 0;
    return MaterialApp(
      title: 'All Adverts',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(

          title: const Text('Adverts'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final album = snapshot.data![index];
                    return Center(
                      child: InkWell(
                         onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdvertScreen()),);
                            },
                        child: Container(
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          album.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          ' ${album.category}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          ' ${album.location}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Response: ${index + 1}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.phone,
                                              color: const Color.fromARGB(
                                                  255, 83, 83, 83)),
                                          SizedBox(width: 5),
                                          Text(album.phone,
                                              style: TextStyle(color: Colors.black)),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                        child: Text(
                                          'Call',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('Something went wrong');
              }
            },
          ),
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
      ),
    );
  }
}

void main() {
  runApp(const Homepage());
}