import 'dart:convert';
import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/service_homepage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int? phone;
  final photo;
  final bool isService;
  // final String photo;
  final int service_id;
  final int shop_id;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.phone,
    required this.photo,
    required this.service_id,
    required this.isService,
    required this.shop_id,
  });
  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
        address:
            json['location'] ?? "No Address", // Provide default value if null
        category:
            json['cat_name'] ?? "No Category", // Provide default value if null
        business_name: json['name'] ?? "No Name",
        photo: json['cat_logo'],
        // Provide default value if null
        phone: json['phone'] as int?, // Cast as nullable int
        // photo: json['photo'] ?? "No Photo", // Provide default value if null
        service_id: json['service_id'],
        shop_id: json['shop_id'] ?? 0,
        isService: true // Assuming service_id will always be provided
        );
  }
}

class ServiceFavorite extends StatefulWidget {
  final String cat_id;
  final String category_name;

  ServiceFavorite({required this.cat_id, required this.category_name});

  @override
  _ServiceFavoriteState createState() => _ServiceFavoriteState();
}

class _ServiceFavoriteState extends State<ServiceFavorite> {
  late Future<List<UserDetail>> data;
  String sortBy = "";
  String userLocation = '23.8103,90.4125'; // example location (Dhaka)

  @override
  void initState() {
    super.initState();
    data = fetchUserDetails(widget.cat_id, sortBy);
  }

  Future<List<UserDetail>> fetchUserDetails(String cat_id, sortBy) async {
    final url =
        'http://192.168.0.102:5000/get_service_data_by_category?cat_id=$cat_id&sort_by=$sortBy&user_location=$userLocation';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userDetails = jsonResponse['service_information'] != null
            ? (jsonResponse['service_information'] as List)
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

  void _sortData(String criteria) {
    setState(() {
      sortBy = criteria;
      data = fetchUserDetails(widget.cat_id, sortBy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaramBD - ${widget.category_name}'),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        leading: IconButton(
          iconSize: 40,
          color: Colors.white,
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement sorting by location nearby
                          _sortData('nearby');
                        },
                        icon: Icon(Icons.location_on),
                        label: Text('Near By'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:
                              sortBy == 'nearby' ? Colors.green : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement sorting by time
                          _sortData('recent');
                        },
                        icon: Icon(Icons.access_time),
                        label: Text('Recent'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:
                              sortBy == "recent" ? Colors.green : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement sorting by most viewed
                          _sortData('most_viewed');
                        },
                        icon: Icon(Icons.visibility),
                        label: Text('Most Viewed'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:
                              sortBy == 'most_viewed' ? Colors.green : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement sorting by most called
                          _sortData('most_called');
                        },
                        icon: Icon(Icons.phone),
                        label: Text('Most Called'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:
                              sortBy == 'most_called' ? Colors.green : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserDetail>>(
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

                        final String pp = user.photo;

                        return Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdvertScreen(
                                          userId: user.service_id.toString(),
                                          isService: user.isService,
                                          advertData: AdvertData(
                                            userId: user.service_id.toString(),
                                            isService: user.isService,
                                            additionalData: user.isService
                                                ? {
                                                    'service_id':
                                                        user.service_id,
                                                  } // Replace with actual service details
                                                : {
                                                    'shop_id': user.shop_id,
                                                  },
                                          ),
                                        )),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromARGB(255, 133, 199, 136)),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    margin: EdgeInsets.only(right: 20),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      border: Border.all(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      child: Image.network(
                                        "http://aarambd.com/cat logo/${user.photo}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 3),
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
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ServiceFavorite(cat_id: "hello", category_name: "mello"),
  ));
}
