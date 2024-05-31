import 'dart:convert';
import 'dart:developer';

import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/ShopsCart.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/service_homepage.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:http/http.dart' as http;

// Data model for category counts
class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int? phone;
  // final String photo;
  final int shop_id;
  final int service_id;
  final bool is_service;

  UserDetail(
      {required this.address,
      required this.business_name,
      required this.category,
      required this.phone,
      // required this.photo,
      required this.shop_id,
      required this.is_service,
      required this.service_id});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
        address:
            json['address'] ?? "No Address", // Provide default value if null
        category:
            json['category'] ?? "No Category", // Provide default value if null
        business_name:
            json['business_name'] ?? "No Name", // Provide default value if null
        phone: json['phone'] as int?, // Cast as nullable int
        // photo: json['photo'] ?? "No Photo", // Provide default value if null
        shop_id: json['shop_id'],
        service_id: json['service_id'] ?? 0,
        is_service: false // Assuming service_id will always be provided
        );
  }
}

class ShopsFavorite extends StatefulWidget {
  final String categoryName;
  ShopsFavorite({required this.categoryName});
  @override
  _ShopsFavoriteState createState() => _ShopsFavoriteState();
}

class _ShopsFavoriteState extends State<ShopsFavorite> {
  late Future<List<UserDetail>> data;
  List<Widget> pages = [
    CartPage(),
    ServiceCart(),
    ShopsCart(),
    ShopsFavorite(categoryName: ""),
    UserProfile(),
  ];

  @override
  void initState() {
    super.initState();
    data = fetchUserDetails(widget.categoryName);
  }

  Future<List<UserDetail>> fetchUserDetails(String category) async {
    final url =
        'http://192.168.0.103:5000/get_shop_data_by_category?category=$category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userDetails = jsonResponse['shop_information'] != null
            ? (jsonResponse['shop_information'] as List)
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
        title: Text(
          'AaramBD - ${widget.categoryName}',
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvertScreen(
                                    userId: user.shop_id.toString(),
                                    isService: user.is_service,
                                    advertData: AdvertData(
                                      userId: user.shop_id.toString(),
                                      isService: user.is_service,
                                      additionalData: user.is_service
                                          ? {
                                              'service_id': user.service_id,
                                            } // Replace with actual service details
                                          : {
                                              'shop_id': user.shop_id,
                                            },
                                    ),
                                  )),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(255, 252, 122, 213)),
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
                                border: Border.all(
                                    width: 3,
                                    color: const Color.fromARGB(
                                        255, 232, 141, 248)),
                              ),
                              // child: Image.memory(
                              //   base64Decode(user.photo),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.business_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    user.address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Modified fetchData function to return both categories and user details

// ignore: must_be_immutable

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShopsFavorite(categoryName: "Auto painting"),
  ));
}
