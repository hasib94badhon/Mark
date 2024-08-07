import 'dart:async';
import 'dart:convert';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/Service_favorite_screen.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/service_homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Data model for category counts
class CategoryCount {
  final int categoryCount;
  final String categoryName;
  final String cat_id;
  final photo;

  CategoryCount(
      {required this.categoryCount,
      required this.categoryName,
      required this.cat_id,
      required this.photo});

  factory CategoryCount.fromJson(Map<String, dynamic> json) {
    return CategoryCount(
        categoryCount: json['count'],
        cat_id: json['cat_id'],
        categoryName: json['name'],
        photo: json['photo']);
  }
}

// Data model for user details
class UserDetail {
  final String address;
  final String business_name;
  final String category;
  final int phone;
  final String photo;
  final int service_id;
  final int shop_id;
  final bool isService;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.phone,
    required this.photo,
    required this.service_id,
    required this.shop_id,
    required this.isService,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      category: json['cat_name'],
      address: json['location'],
      business_name: json['name'],
      phone: json['phone'],
      service_id: json['service_id'],
      shop_id: json['service_id'] ?? 0,
      photo: json['photo'],
      isService: true,
    );
  }
}

// Modified fetchData function to return both categories and user details
Future<Map<String, List<dynamic>>> fetchData() async {
  final url = 'http://192.168.0.102:5000//get_service_data';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final categoryCounts = (jsonResponse['category_count'] as List)
        .map((data) => CategoryCount.fromJson(data))
        .toList();
    final userDetails = (jsonResponse['service_information'] as List)
        .map((data) => UserDetail.fromJson(data))
        .toList();

    return {
      'categoryCounts': categoryCounts,
      'userDetails': userDetails,
    };
  } else {
    throw Exception('Failed to load data from API');
  }
}

class ServiceCart extends StatelessWidget {
  final Future<Map<String, List<dynamic>>> data;

  ServiceCart({Key? key})
      : data = fetchData(),
        super(key: key);

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
                            onTap: () {},
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
                            //margin: EdgeInsets.all(5),
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceFavorite(
                                      cat_id: category.cat_id,
                                      category_name: category.categoryName,
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
                                            image: NetworkImage(category.photo),
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
                                            bottomRight: Radius.circular(
                                              10,
                                            ))),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          color:
                                              Color.fromARGB(255, 255, 255, 255)
                                                  .withOpacity(0.6),
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
                                            userId: user.service_id.toString(),
                                            isService: user.isService,
                                            advertData: AdvertData(
                                              userId:
                                                  user.service_id.toString(),
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
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
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
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 135,
                                                height: 135,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Colors.lightGreen),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Image.network(
                                                        user.photo,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )),
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
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
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
                                        //lower part
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
                                                //Text('${user.viewsCount}'),
                                                SizedBox(width: 16),
                                                Icon(Icons.share, size: 16),
                                                SizedBox(width: 6),
                                                //Text('${user.shares}'),
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
    home: ServiceCart(),
  ));
}
