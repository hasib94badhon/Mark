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
import 'package:http/http.dart' as http;

// Data model for category counts
class CategoryCount {
  final int categoryCount;
  final String categoryName;

  CategoryCount({
    required this.categoryCount,
    required this.categoryName,
  });

  factory CategoryCount.fromJson(Map<String, dynamic> json) {
    return CategoryCount(
      categoryCount: json['count'],
      categoryName: json['name'],
    );
  }
}

// Data model for user details
class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int? phone;
  final String photo; 
  final int service_id;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.phone,
    required this.photo,
    required this.service_id,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      address: json['address'] ?? "No Address", // Provide default value if null
      category:
          json['category'] ?? "No Category", // Provide default value if null
      business_name:
          json['business_name'] ?? "No Name", // Provide default value if null
      phone: json['phone'] as int?, // Cast as nullable int
      photo: json['photo'] ?? "No Photo", // Provide default value if null
      service_id:
          json['service_id'], // Assuming service_id will always be provided
    );
  }
}

class ShopsFavorite extends StatefulWidget {
  @override
  _ShopsFavoriteState createState() => _ShopsFavoriteState();
}

class _ShopsFavoriteState extends State<ShopsFavorite> {
  int pageIndex = 0;
  late Future<Map<String, List<dynamic>>> data;

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  Future<Map<String, List<dynamic>>> fetchData() async {
    var client = http.Client();
    final url = 'http://192.168.0.102:5000/get_service_data';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final categoryCounts = jsonResponse['category_count'] != null
            ? (jsonResponse['category_count'] as List)
                .map((data) => CategoryCount.fromJson(data))
                .toList()
            : <CategoryCount>[];
        print(categoryCounts);
        final userDetails = jsonResponse['service_information'] != null
            ? (jsonResponse['service_information'] as List)
                .map((data) => UserDetail.fromJson(data))
                .toList()
            : <UserDetail>[];

        return {
          'categoryCounts': categoryCounts,
          'userDetails': userDetails,
        };
      } else {
        throw Exception('Failed to load data from API');
      }
    } on http.ClientException catch (e) {
      throw Exception("Fail to connect to API:${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occured:${e.toString()}");
    }
  }

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
        backgroundColor: Colors.green[100],
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
      body: FutureBuilder<Map<String, List<dynamic>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final categories =
                  snapshot.data!['categoryCounts'] as List<CategoryCount>;
              final users = snapshot.data!['userDetails'] as List<UserDetail>;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Button
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 133, 199, 136)),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: Color.fromARGB(255, 133, 199, 136)),
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
                        itemCount: users.length - 700,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Container(
                            width: 160,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2, color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  base64Decode(user.photo),
                                  fit: BoxFit.cover,
                                )
                                // child: Image.asset(
                                //   imageList[index],
                                //   fit: BoxFit.cover,
                                // ),
                                ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    // Product List
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length - 800,
                        itemBuilder: (context, index) {
                          if (users.isNotEmpty) {
                            final user = users[index];
                            // Widget code here
                            return Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceHomepage()),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 133, 199, 136)),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                width: 3,
                                                color: Colors.greenAccent),
                                          ),
                                          child: Image.memory(
                                            base64Decode(user.photo),
                                            fit: BoxFit.cover,
                                          )
                                          // Image.asset(
                                          //   user.photo[index],
                                          //   fit: BoxFit.cover,
                                          // ),
                                          ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            // Row(
                                            //   children: [
                                            //     Icon(Icons.star,
                                            //         color: Colors.amber),
                                            //     Text(user.category),
                                            //     SizedBox(width: 10),
                                            //     Text(
                                            //       user.phone?.toString() ?? 'No Phone',
                                            //       style: TextStyle(
                                            //         fontWeight: FontWeight.bold,
                                            //         color: Color.fromARGB(
                                            //             255, 133, 199, 136),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: NavigationScreen(),
      
    );
  }
}

// Modified fetchData function to return both categories and user details

// ignore: must_be_immutable

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShopsFavorite(),
  ));
}
