import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Future<Album> fetchAlbum() async {
//   final response = await http
//       .get(Uri.parse('http://127.0.0.1:5000'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

// class Album {
//   final String date;
//   final int id;
//   final String phone;
//   final dynamic password;

//   const Album({
//     required this.date,
//     required this.id,
//     required this.phone,
//     required this.password,

//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'date': String date,
//         'id': int id,
//         'phone': String phone,
//         'password': dynamic password,
//       } =>
//         Album(
//           date: date,
//           id: id,
//           phone: phone,
//           password: password
         
//         ),
//       _ => throw const FormatException('Failed to load album.'),
//     };
//   }
// }

// // void main() => runApp(const Homepage());

// class Homepage extends StatefulWidget {
//   const Homepage ({super.key});

//   @override
//   State<Homepage> createState() => _MyAppState();
// }

// class _MyAppState extends State<Homepage> {
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch Data Example'),
//         ),
//         body: Center(
//           child: FutureBuilder<Album>(
//             future: futureAlbum,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Text(snapshot.data!.phone);
//               } else if (snapshot.hasError) {
//                 return Text('${snapshot.error}');
//               }

//               // By default, show a loading spinner.
//               return const CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class Album {
  final String date;
  final int id;
  final int number;
  final dynamic password;

  const Album({
    required this.date,
    required this.id,
    required this.number,
    required this.password,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      date: json['date'] ?? '', // Handle null value by providing a default empty string
      id: json['id'] ?? 0, // Handle null value by providing a default value (0 in this case)
      number: json['number'] ?? '', // Handle null value by providing a default empty string
      password: json['password'], // No need to handle null for dynamic types
    );
  }
}

Future<List<Album>> fetchAlbum() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000'));

  if (response.statusCode == 200) {
    // If the server returns a successful response, parse the JSON
    final List<dynamic> data = jsonDecode(response.body)['data'];
     print('Fetched data: $data'); // Add debug print
    // Map the dynamic list to a list of Album objects
    return data.map((json) => Album.fromJson(json)).toList();
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
                print('Data length: ${snapshot.data!.length}'); // Add debug print
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final album = snapshot.data![index];
                    print('Album phone: ${album.number}'); // Add debug print
                    // return ListTile(
                    //   title: Text(album.phone),
                    //   textColor: Colors.white,
                    //   tileColor: Colors.red,
                    // );
                    return Container(
                      height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF0DD),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 2,
                          ),
                        ],
                  ),
                  child: Column(
                    children: [
                      Text("0"+album.number.toString()),
                      Text(album.date)
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
