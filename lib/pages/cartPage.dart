import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Import FavoriteScreen

// Data model for category counts
class CategoryCount {
  final int categoryCount;
  final String categoryName;
  final String cat_id;
  final photo;

  CategoryCount({
    required this.categoryCount,
    required this.categoryName,
    required this.cat_id,
    required this.photo,
  });

  factory CategoryCount.fromJson(Map<String, dynamic> json) {
    return CategoryCount(
      categoryCount: json['count'],
      categoryName: json['cat_name'],
      cat_id: json['cat_id'],
      photo: json['cat_logo'],
    );
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
      category: json['cat_name'] ?? '',
      business_name: json['name'] ?? '',
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
  final String userPhone;

  CartPage({required this.userPhone});

  @override
  _CartPageState createState() => _CartPageState(userPhone: userPhone);
}

class _CartPageState extends State<CartPage> {
  final String userPhone;
  List<String> categories = [];
  List<String> filteredCategories = [];
  final TextEditingController searchController = TextEditingController();
  late SearchController searchBarController;

  _CartPageState({required this.userPhone});
  late Future<Map<String, List<dynamic>>> data;

  @override
  void initState() {
    super.initState();
    data = fetchData();
    fetchCategories();
    searchBarController = SearchController();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.102:5000/get_categories_name'),
    );

    if (response.statusCode == 200) {
      final category_data = json.decode(response.body);
      setState(() {
        categories = List<String>.from(category_data['categories']);
        filteredCategories = categories;
      });
    } else {
      print("Failed to fetch categories: ${response.statusCode}");
    }
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<Map<String, List<dynamic>>> fetchData() async {
    final url = 'http://192.168.0.102:5000/get_combined_data';
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.all(6),
                      child: SearchAnchor(
                        builder: (BuildContext context,
                            SearchController controller) {
                          return SearchBar(
                            controller: searchBarController,
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onTap: () {
                              controller.openView();
                            },
                            onChanged: (query) {
                              filterCategories(query);
                              controller.openView();
                            },
                            leading: const Icon(Icons.search),
                          );
                        },
                        suggestionsBuilder: (BuildContext context,
                            SearchController controller) {
                          return List<ListTile>.generate(
                              filteredCategories.length, (int index) {
                            final item = filteredCategories[index];
                            return ListTile(
                              title: Text(item),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => FavoriteScreen(
                                //       categoryName: categories.c,
                                //       // cat_id: item,
                                //     ),
                                //   ),
                                // );
                              },
                            );
                          });
                        },
                      ),
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoriteScreen(
                                      categoryName: category.categoryName,
                                      cat_id: category.cat_id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Stack(children: [
                                Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.lightGreen),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(45),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "https://aarambd.com/cat logo/${category.photo}",
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 5,
                                  right: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                        child: Text(
                                          "${category.categoryName} (${category.categoryCount})",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
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
                                                    }
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
                                  elevation: 2,
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
                                                width: 135,
                                                height: 135,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 4,
                                                    color: Colors.lightGreen,
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
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
    home: CartPage(
      userPhone: "",
    ),
  ));
}
