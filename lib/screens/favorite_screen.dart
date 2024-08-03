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
  final String photo;
  final int phone;
  final int shop_id;
  final int service_id;
  final int userId;
  final bool isservice;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.photo,
    required this.phone,
    required this.userId,
    required this.shop_id,
    required this.service_id,
    required this.isservice,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    int serviceId = json['service_id'] ?? 0;
    int shopId = json['shop_id'] ?? 0;
    return UserDetail(
      address: json['location'] ?? '',
      category: json['cat_id'] ?? '',
      business_name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      phone: json['phone'] ?? 0,
      userId: serviceId != 0 ? serviceId : shopId,
      service_id: serviceId,
      shop_id: shopId,
      isservice: serviceId != 0,
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final String cat_id;
  final String categoryName;

  FavoriteScreen({required this.categoryName, required this.cat_id});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<UserDetail>> serviceData;
  late Future<List<UserDetail>> shopData;
  String sortBy = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    serviceData = fetchUserDetails(widget.cat_id, 'service', sortBy);
    shopData = fetchUserDetails(widget.cat_id, 'shops', sortBy);
  }

  Future<List<UserDetail>> fetchUserDetails(
      String cat_id, String dataType, String sortBy) async {
    final url =
        'http://192.168.0.102:5000/get_data_by_category?cat_id=$cat_id&data_type=$dataType&sort_by=$sortBy';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userDetails = jsonResponse['${dataType}_information'] != null
            ? (jsonResponse['${dataType}_information'] as List)
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

  void updateSorting(String newSortBy) {
    setState(() {
      sortBy = newSortBy;
      fetchData();
    });
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
                          updateSorting('nearby');
                        },
                        icon: Icon(Icons.location_on),
                        label: Text('Near By'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          updateSorting('recent');
                        },
                        icon: Icon(Icons.access_time),
                        label: Text('Recent'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
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
                          updateSorting('most_viewed');
                        },
                        icon: Icon(Icons.visibility),
                        label: Text('Most Viewed'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          updateSorting('most_called');
                        },
                        icon: Icon(Icons.phone),
                        label: Text('Most Called'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
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
              future: Future.wait([serviceData, shopData])
                  .then((results) => results.expand((x) => x).toList()),
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
                                            userId: user.userId.toString(),
                                            isService: user.isservice,
                                            additionalData: user.isservice
                                                ? {
                                                    'service_id':
                                                        user.service_id,
                                                  }
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
                                        "http://aarambd.com/photo/${user.photo}",
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

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: FavoriteScreen(
//       categoryName: "Auto painting",
//     ),
//   ));
// }
