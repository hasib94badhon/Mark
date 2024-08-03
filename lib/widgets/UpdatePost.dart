import 'package:flutter/material.dart';

class UpdatePost extends StatelessWidget {
  final List<dynamic> posts;

  UpdatePost({required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Day Live'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            // leading: Image.network(
            //   'https://aarambd.com/photo/${post['photo']}',
            //   width: 50,
            //   height: 50,
            //   fit: BoxFit.cover,
            // ),
            title: Text(post['description']),
            subtitle: Text(
                'name:${post['name']},\nphone:${post['phone']},\ncategory:${post['category']},\nshare:${post['share']},\nlike:${post['like']},\nview:${post['view']},time:${post['time']}'),
          );
        },
      ),
    );
  }
}
