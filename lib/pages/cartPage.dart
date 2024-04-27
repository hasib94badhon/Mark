import 'dart:async';
import 'dart:convert';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
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
      categoryCount: json['category_count'],
      categoryName: json['category_name'],
    );
  }
}

// Data model for user details
class UserDetail {
  final String category;
  final String location;
  final String name;
  final int phone;
  final int regId;
  final int userId;
  final int viewsCount;
  final int shares;

  UserDetail({
    required this.category,
    required this.location,
    required this.name,
    required this.phone,
    required this.regId,
    required this.userId,
    required this.viewsCount,
    required this.shares,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      category: json['category'],
      location: json['location'],
      name: json['name'],
      phone: json['phone'],
      regId: json['reg_id'],
      userId: json['user_id'],
      viewsCount: json['viewsCount'],
      shares: json['shares'],
    );
  }
}

// Modified fetchData function to return both categories and user details
Future<Map<String, List<dynamic>>> fetchData() async {
  final url = 'http://192.168.0.101:5000/get_category_and_counts_all_info';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final categoryCounts = (jsonResponse['category_counts'] as List)
        .map((data) => CategoryCount.fromJson(data))
        .toList();
    final userDetails = (jsonResponse['all_users_data'] as List)
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

class CartPage extends StatelessWidget {
  final Future<Map<String, List<dynamic>>> data;

  CartPage({Key? key})
      : data = fetchData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaramBD'),
        backgroundColor: Colors.white12,
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
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          childAspectRatio: 0.93,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final count = categories[index];
                          return Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavoriteScreen()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(250),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${count.categoryName} (${count.categoryCount})',
                                  style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                          ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10,),
                    Divider(),
                    Expanded(
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
                                      builder: (context) => AdvertScreen()),
                                );
                              },
                              child: Container(
                                color: Colors.blue,
                                child: Card(
                                  margin: EdgeInsets.only(top: 10,left: 10, right: 10),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          user.category,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(user.location),
                                        SizedBox(height: 5),
                                        Divider(),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('📞 0${user.phone}'),
                                            Row(
                                              children: [
                                                Icon(Icons.remove_red_eye,
                                                    size: 16),
                                                SizedBox(width: 4),
                                                Text('${user.viewsCount}'),
                                                SizedBox(width: 16),
                                                Icon(Icons.share, size: 16),
                                                SizedBox(width: 6),
                                                Text('${user.shares}'),
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
    home: CartPage(),
  ));
}
