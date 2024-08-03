import 'package:flutter/material.dart';

class MostUsedCategoriesPage extends StatelessWidget {
  final List<dynamic> categories;

  MostUsedCategoriesPage({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Use'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Image.network(
              'https://aarambd.com/cat logo/${category['cat_logo']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(category['cat_name']),
            subtitle: Text('Total Views: ${category['total_views']}'),
          );
        },
      ),
    );
  }
}
