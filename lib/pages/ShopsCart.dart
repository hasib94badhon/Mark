import 'dart:async';
import 'dart:convert';
import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/advert_screen.dart';
import 'package:aaram_bd/screens/favorite_screen.dart';
import 'package:aaram_bd/screens/shops_favorite_screen.dart';
import 'package:aaram_bd/screens/shops_homepage.dart';
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
  final photo;
  final int shop_id;

  UserDetail({
    required this.address,
    required this.business_name,
    required this.category,
    required this.phone,
    required this.photo,
    required this.shop_id,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      address: json['address'],
      business_name: json['business_name'],
      category: json['category'],
      phone: json['phone'],
      photo: json['photo'],
      shop_id: json['shop_id'],
    );
  }
}

// Modified fetchData function to return both categories and user details
Future<Map<String, List<dynamic>>> fetchData() async {
  final url = 'http://192.168.0.103:5000//get_shops_data';
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

class ShopsCart extends StatelessWidget {
  final Future<Map<String, List<dynamic>>> data;

  ShopsCart({Key? key})
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
        backgroundColor: Colors.purple[100],
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
                          crossAxisCount: 3,
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
                                      builder: (context) => ShopsFavorite(
                                          categoryName: category.categoryName)),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      '${category.categoryName} ${category.categoryCount}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
                                      builder: (context) => ShopsHomepage()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.purple[100],
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      top: 3, left: 4, right: 5, bottom: 6),
                                  elevation: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
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
                                                    BorderRadius.circular(60),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Image.network(
                                                  user.photo,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.all(6),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.business_name,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      user.category,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black54,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      user.address,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Divider(),
                                        SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '📞 +880${user.phone}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.remove_red_eye,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                SizedBox(width: 4),
                                                // Text('${user.viewsCount}'),
                                                SizedBox(width: 16),
                                                Icon(Icons.share,
                                                    size: 16,
                                                    color: Colors.grey[600]),
                                                SizedBox(width: 6),
                                                // Text('${user.shares}'),
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
    home: ShopsCart(),
  ));
}
