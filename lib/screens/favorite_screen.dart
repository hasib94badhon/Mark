import 'dart:async';
import 'dart:convert';

import 'package:aaram_bd/pages/Homepage.dart';
import 'package:aaram_bd/screens/navigation_screen.dart';
import 'package:aaram_bd/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:aaram_bd/pages/cartPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class Album {
  final int service_id;
  final String category;
  final String business_name;
  final String address;
  final String phone;

  const Album({
    required this.service_id,
    required this.category,
    required this.business_name,
    required this.address,
    required this.phone,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      service_id: json['service_id'] ?? 0,
      category: json['category'] ?? '',
      business_name: json['business_name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}


Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.101:5000/get_service_data'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> userData = data['category_data'];

    return userData.map((json) => Album.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}


class FavoriteScreen extends StatefulWidget {

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  int pageIndex = 0;

  late Future<List<Album>> futureAlbum;

  @override
  void initState(){
    super.initState();
    futureAlbum = fetchAlbum();
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
        backgroundColor: Colors.blue[100],
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Button
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(horizontal: 10,),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.blue),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.blue),
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

          SizedBox(height: 10),
          // Product List
          Expanded(
            

            child: FutureBuilder<List<Album>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return CircularProgressIndicator();
                } else if(snapshot.hasError){
                  return Text('Error:${snapshot.error}');
                }else if (snapshot.hasData){
                  return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final Album = snapshot.data![index];
                    return Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.blue),
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
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 3,color: Colors.greenAccent),
                                ),
                                // child: Image.asset(
                                //   //imageList[index],
                                //   //fit: BoxFit.cover,
                                // ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Album.category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(height: 5),
                                    Text(
                                      Album.address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        //Text(reviews[index]),
                                        SizedBox(width: 10),
                                        // Text(
                                        //   prices[index],
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.blue,
                                        //   ),
                                        // ),
                                      ],
                                    ),
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
                else{
                  return Text('Something went wrong');
                }

                
              }
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 80,
        activeColor: Color.fromARGB(255, 0, 74, 134),
        inactiveColor: Colors.black,
        iconSize: 30,
        icons: [
          CupertinoIcons.back,
          CupertinoIcons.home,
        ],
        activeIndex: pageIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        elevation: 8,
        onTap: (index) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigationScreen()),
            );
          });
        },
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FavoriteScreen(),
  ));
}