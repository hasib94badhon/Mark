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
  final int phone;
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
      category: json['category'],
      address: json['address'],
      business_name: json['business_name'],
      phone: json['phone'],
      service_id: json['service_id'],
      photo: json['photo'],
    );
  }
}

// Modified fetchData function to return both categories and user details
Future<Map<String, List<dynamic>>> fetchData() async {
  final url = 'http://192.168.0.103:5000//get_service_data';
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
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            border: Border.all(width: 1, color: Colors.black12),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "Service",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 0.92,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Card(
                            elevation: 2.0,
                            margin: EdgeInsets.all(5),
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
                                    height: 100,
                                    width: 100,
                                    margin: EdgeInsets.only(top: 8, bottom: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${category.categoryName} \n ${category.categoryCount}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          // return Container(
                          //   padding: EdgeInsets.only(top: 5),
                          //   child: ListTile(
                          //     title: Text(user.name),
                          //     subtitle: Text('${user.category}-${user.location}\n0${user.phone}'),
                          //     trailing: Text('Views: ${user.viewsCount}, Shares: ${user.shares}'),

                          //   ),
                          // );
                          return Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ServiceHomepage()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Card(
                                  margin: EdgeInsets.only(
                                      top: 5, left: 5, right: 5),
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
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.lightGreen),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.memory(
                                                      base64Decode(user.photo),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        user.business_name,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 5),
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
                                                      SizedBox(height: 5),
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

                                        SizedBox(height: 5),
                                        Divider(),
                                        SizedBox(height: 5),
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
