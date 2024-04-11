import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int user_id;
  final int reg_id;
  final String phone;
  final String name;
  final String location;
  final String category;

  const Album({
    required this.user_id,
    required this.reg_id,
    required this.name,
    required this.phone,
    required this.category,
    required this.location,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      user_id: json['user_id'] ?? 0,
      reg_id: json['reg_id'] ?? 0,
      name: json['name'],
      phone: json['phone'],
      category: json['category'],
      location: json['location'],
    );
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.101:5000/get_users_data'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> userData = data['users_data'];

    return userData.map((json) => Album.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vcards',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vcards'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final album = snapshot.data![index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person),
                            ),
                            title: Text(album.name),
                            subtitle: Text(album.category),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Location: ${album.location}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(album.phone),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Call'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
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
