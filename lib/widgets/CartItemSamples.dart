import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
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
      user_id: json['user_id'] ?? 0, // Handle null value by providing a default value (0 in this case)
      reg_id: json['reg_id']?? 0,
      name:json['name'],
      phone: json['phone'],
      category: json['category'],
      location: json['location']
     // No need to handle null for dynamic types
    );
  }
}

Future<List<Album>> fetchAlbum() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/get_users_data'));

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

class CartItem extends StatefulWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  State<CartItem> createState() => CartItemsSamples();
}

class CartItemsSamples extends State<CartItem> {

  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      
      child: Column
      (children: [
        for (int i = 1; i < 10; i++)
          Container(
            height: 80,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Radio(
                      value: 1,
                      groupValue: 1,
                      onChanged: (_) {},
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.green.withOpacity(.32);
                        }
                        return Colors.green;
                      })),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    color: Colors.transparent,
                    height: 75,
                    width: 75,
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset("images/image$i.png"),
                  ),
                ),
                Spacer(),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 30,
                        width: 250,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Advertise Title",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 192, 50, 145),
                              ),
                            ),
                            Text(
                              "Views: 8546",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C53A5),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 30,
                        width: 250,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Response : 55",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C53A5),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                        )
                      ]),
                  //color: Colors.yellow,
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.all(10),
                  child: Icon(Icons.call_end_sharp),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                  )
                                ]),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ]),
    );
  }
}
