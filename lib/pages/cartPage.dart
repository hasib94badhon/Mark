import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/pages/ServiceCart.dart';
import 'package:aaram_bd/pages/ShopsCart.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Data model for category counts
class CategoryCount {
  final int categoryCount;
  final String categoryName;
  final photo;

  CategoryCount({
    required this.categoryCount,
    required this.categoryName,
    required this.photo,
  });

  factory CategoryCount.fromJson(Map<String, dynamic> json) {
    return CategoryCount(
        categoryCount: json['count'],
        categoryName: json['category'],
        photo: json['photo']);
  }
}

// Data model for user details
class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final photo;
  final int phone;
  final int shop_id;
  final int service_id;
  final int userId;
  final bool isservice;

  UserDetail(
      {required this.address,
      required this.business_name,
      required this.category,
      required this.photo,
      required this.phone,
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

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<Map<String, List<dynamic>>> data;
  String categoryName = "Auto painting"; // Example category name

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  // Modified fetchData function to return both categories and user details
  Future<Map<String, List<dynamic>>> fetchData() async {
    final url = 'http://192.168.0.103:5000/get_combined_data';
    int retries = 3;
    for (int i = 0; i < retries; i++) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 60)); // Increase timeout duration
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final categoryCounts = jsonResponse['category_count'] != null
              ? (jsonResponse['category_count'] as List)
                  .map((data) => CategoryCount.fromJson(data))
                  .toList()
              : <CategoryCount>[];
          print(categoryCounts);
          final userDetails = jsonResponse['combined_information'] != null
              ? (jsonResponse['combined_information'] as List)
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
      } on SocketException catch (e) {
        if (i == retries - 1) {
          throw Exception("Failed to connect to API: ${e.message}");
        }
      } on http.ClientException catch (e) {
        if (i == retries - 1) {
          throw Exception("Failed to connect to API: ${e.message}");
        }
      } catch (e) {
        if (i == retries - 1) {
          throw Exception("An unexpected error occurred: ${e.toString()}");
        }
      }
      await Future.delayed(Duration(seconds: 2)); // Delay before retrying
    }
    throw Exception("Failed to connect to API after $retries attempts");
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceCart(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopsCart(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.all(6),
                      child: SearchAnchor(builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          controller: controller,
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: (_) {
                            controller.openView();
                          },
                          leading: const Icon(Icons.search),
                        );
                      }, suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        return List<ListTile>.generate(5, (int index) {
                          final String item = 'item $index';
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                              });
                            },
                          );
                        });
                      }),
                    ),
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 0.92,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45)),
                            elevation: 10.0,
                            color: Colors.white,
                            //margin: EdgeInsets.all(3),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoriteScreen(
                                      categoryName: category.categoryName,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.lightGreen),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.network(
                                        "http://aarambd.com/photo/${category.photo}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${category.categoryName}  ${category.categoryCount}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          //backgroundColor: Colors.white,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
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
                                                    } // Replace with actual service details
                                                  : {
                                                      'shop_id': user.shop_id,
                                                    },
                                            ),
                                          )),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      top: 3, left: 4, right: 5, bottom: 6),
                                  elevation: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.lightGreen,
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                child: Center(
                                                  child: Image.network(
                                                    user.photo,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(6),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        user.business_name,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        user.category,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.black54,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        user.address,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Divider(),
                                        SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('📞 +880${user.phone}'),
                                            Row(
                                              children: [
                                                Icon(Icons.remove_red_eye,
                                                    size: 16),
                                                SizedBox(width: 4),
                                                SizedBox(width: 16),
                                                Icon(Icons.share, size: 16),
                                                SizedBox(width: 6),
                                              ],
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
                      ),
                    )
                  ],
                ),
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
    home: CartPage(),
  ));
}
