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
  final int phone;
  final photo;
  final int shop_id;
  final int service_id;
  final int userId;
  final bool isservice;

  UserDetail(
      {required this.address,
      required this.business_name,
      required this.category,
      required this.phone,
      required this.photo,
      required this.userId,
      required this.shop_id,
      required this.service_id,
      required this.isservice});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    int serviceId = json['service_id'] ?? 0;
    int shopId = json['shop_id'] ?? 0;
    return UserDetail(
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      business_name: json['business_name'] ?? '',
      photo: json['photo'],
      phone: json['phone'] ?? 0,
      userId: serviceId != 0 ? serviceId : shopId,
      service_id: serviceId,
      shop_id: shopId,
      isservice: serviceId != 0,
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final String categoryName;

  FavoriteScreen({required this.categoryName});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<UserDetail>> data;

  @override
  void initState() {
    super.initState();
    data = fetchUserDetails(widget.categoryName);
  }

  Future<List<UserDetail>> fetchUserDetails(String category) async {
    final url =
        'http://192.168.0.103:5000/get_service_data_by_category?category=$category';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaramBD - ${widget.categoryName}'),
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
                                    userId: user.userId.toString(),
                                    isService: user.isservice,
                                    advertData: AdvertData(
                                      userId: user.service_id.toString(),
                                      isService: user.isservice,
                                      additionalData: user.isservice
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
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(255, 133, 199, 136)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                    width: 3, color: Colors.greenAccent),
                              ),
                              child: Image.network(
                                "http://aarambd.com/photo/${user.photo}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FavoriteScreen(categoryName: "Auto painting"),
  ));
}
