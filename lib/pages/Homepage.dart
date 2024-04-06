import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  // final String date;
  final int user_id;
  final int reg_id;
  final String phone;
  final String name;
  final String location;
  final String category;

  const Album({
    // required this.date,
    required this.user_id,
    required this.reg_id,
    required this.name,
    required this.phone,
    required this.category,
    required this.location,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        // date: json['date'] ?? '', // Handle null value by providing a default empty string
        user_id: json['user_id'] ??
            0, // Handle null value by providing a default value (0 in this case)
        reg_id: json['reg_id'] ?? 0,
        name: json['name'],
        phone: json['phone'],
        category: json['category'],
        location: json['location']
        // No need to handle null for dynamic types
        );
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:5000/get_users_data'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> userData =
        data['users_data']; // Accessing the users_data key

    print('Fetched data: $userData'); // Add debug print

    // Map the dynamic list to a list of Album objects
    return userData.map((json) => Album.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load album');
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _MyAppState();
}

class _MyAppState extends State<Homepage> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for the data to be loaded, show a loading spinner.
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurred, display the error message.
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // If data is available, display it using ListView.
                print(
                    'Data length: ${snapshot.data!.length}'); // Add debug print
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final album = snapshot.data![index];
                    //print('Album phone: ${album.phone}');
                    //print('Album name: ${album.name}');
                    //print('Album name: ${album.category}');
                    //print('Album name: ${album.location}');
                    //print('Album name: ${album.reg_id}');
                    // Add debug print
                    // return ListTile(
                    //   title: Text(album.phone),
                    //   textColor: Colors.white,
                    //   tileColor: Colors.red,
                    // );
                    return Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 7, bottom: 7),
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(2),
                                  height: 20,
                                  width: 220,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //       color: Colors.black12,
                                  //       blurRadius: 2,
                                  //       spreadRadius: 3,
                                  //     ),
                                  //   ],
                                  // ),
                                  child: 
                                  Center(child: Text(album.name,style: TextStyle(fontSize: 18,),))),

                                  Container(
                                      height: 20,
                                      width: 160,
                                  //     decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //       color: Colors.black12,
                                  //       blurRadius: 2,
                                  //       spreadRadius: 3,
                                  //     ),
                                  //   ],
                                  // ),
                                  child: Center(child: Text(album.category))),
                              Container(
                                  //
                                  height: 30,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Center(child: Text(album.phone))),
                            ],
                          ),
                          //SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      //margin: EdgeInsets.all(5),
                                      height: 40,
                                      width: 160,
                                  //     decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //       color: Colors.black12,
                                  //       blurRadius: 2,
                                  //       spreadRadius: 3,
                                  //     ),
                                  //   ],
                                  // ),
                                  child: Center(child: Text(album.category))),
                                  SizedBox(width: 5),
                                  Container(
                                      //
                                      height: 30,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      child: Text(album.location)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                      //
                                      height: 20,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(album.category)),
                                  SizedBox(width: 5),
                                  Container(
                                      height: 20,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(album.location)),
                                ],
                              ),
                            ],
                          ),

                          // Text(album.date)
                        ],

                        
                      ),

                    );
                  },
                );
              } else {
                // Default case: If none of the above conditions are met, show a generic error message.
                return const Text('Something went wrong');
              }
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Homepage());
}
