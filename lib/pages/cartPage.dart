import 'dart:async';
import 'dart:convert';
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

// Fetch data from the API
Future<List<CategoryCount>> fetchData() async {
  final response = await http.get(Uri.parse('http://192.168.0.101:5000/get_category_and_counts_all_info'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['category_counts'];
    return jsonResponse.map((data) => CategoryCount.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data from API');
  }
}

class CartPage extends StatelessWidget {
  final Future<List<CategoryCount>> data;

  CartPage({Key? key})
      : data = fetchData(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaramBD Categories'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<CategoryCount>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.90,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CategoryCount count = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${count.categoryName} (${count.categoryCount})',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
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
