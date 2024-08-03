import 'package:aaram_bd/widgets/FloatingPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'MostUsedCategoriesPage.dart';
import 'UpdatePost.dart'; // Import the new widget

class AppDrawer extends StatefulWidget {
  final String userPhone;

  AppDrawer({
    required this.userPhone,
  });

  @override
  _AppDrawerState createState() => _AppDrawerState(userPhone: userPhone);
}

class _AppDrawerState extends State<AppDrawer> {
  final String userPhone;
  int _selectedIndex = -1;
  String userName = "";
  String userPhotoUrl = 'https://www.example.com/profile_picture.jpg';
  String userMobile = "+880123456789";

  _AppDrawerState({required this.userPhone});

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.102:5000/get_user_by_phone?phone=$userPhone'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userName = data['name'] ?? "User Name";
        userPhotoUrl = data['photo']?.isNotEmpty == true
            ? data['photo'][0]
            : 'https://www.example.com/profile_picture.jpg';
        userMobile = userPhone; // Or fetch from data if available
      });
    } else {
      // Handle the error
      print("Failed to fetch user data: ${response.statusCode}");
    }
  }

  Future<void> fetchMostUsedCategory() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.102:5000/get_most_used_category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MostUsedCategoriesPage(
            categories: data['most_used_cat'],
          ),
        ),
      );
    } else {
      // Handle the error
      print("Failed to fetch most used category data: ${response.statusCode}");
    }
  }

  Future<void> mostUpdatePost() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.102:5000/get_today_post'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UpdatePost(
            posts: data['most_update_post'],
          ),
        ),
      );
    } else {
      // Handle the error
      print("Failed to fetch most used category data: ${response.statusCode}");
    }
  }

  void _onItemTap(int index, String title, String content) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pop(context);

    if (title == 'Daily Use') {
      fetchMostUsedCategory();
    } else if (title == 'To-day Live') {
      mostUpdatePost();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FloatingPage(
            title: title,
            content: content,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black26,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Account description container
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black26,
            ),
            child: Column(
              children: [
                // Profile picture
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userPhotoUrl, // Replace with your image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                    height:
                        10), // Adds spacing between the profile picture and the name
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        5), // Adds spacing between the name and the contact number
                Text(
                  userPhone, // Replace with the actual contact number
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Divider between account section and menu items
          Divider(
            color: Colors.black,
            height: 5,
          ),
          // Drawer menu items
          _createDrawerItem(
            icon: Icons.home,
            text: 'Daily Use',
            index: 0,
            title: 'Daily Use',
            content: 'Content for Daily Use',
            textSize: 18,
          ),
          _createDrawerItem(
            icon: Icons.shopping_cart,
            text: 'Social Market',
            index: 1,
            title: 'Social Market',
            content: 'Content for Social Market',
            textSize: 18,
          ),
          _createDrawerItem(
            icon: Icons.live_tv,
            text: 'To-day Live',
            index: 2,
            title: 'To-day Live',
            content: 'Content for To-day Live',
            textSize: 18,
          ),
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'My Contacts',
            index: 3,
            title: 'My Contacts',
            content: 'Content for My Contacts',
            textSize: 20,
          ),
          _createDrawerItem(
            icon: Icons.phone,
            text: 'Emergency Contacts',
            index: 4,
            title: 'Emergency Contacts',
            content: 'Content for Emergency Contacts',
            textSize: 20,
          ),
          _createDrawerItem(
            icon: Icons.business,
            text: 'Business',
            index: 5,
            title: 'Business',
            content: 'Content for Business',
            textSize: 22,
          ),
          _createDrawerItem(
            icon: Icons.group,
            text: 'Collaborators',
            index: 6,
            title: 'Collaborators',
            content: 'Content for Collaborators',
            textSize: 22,
          ),
          _createDrawerItem(
            icon: Icons.contact_mail,
            text: 'Contact AaramBD',
            index: 7,
            title: 'Contact AaramBD',
            content: 'Content for Contact AaramBD',
            textSize: 22,
          ),
          _createDrawerItem(
            icon: Icons.policy,
            text: 'Terms and policies',
            index: 8,
            title: 'Terms and policies',
            content: 'Content for Terms and policies',
            textSize: 22,
          ),
          _createDrawerItem(
            icon: Icons.more,
            text: 'More',
            index: 9,
            title: 'More',
            content: 'Content for More',
            textSize: 22,
          ),
          Divider(
            color: Colors.black,
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required int index,
    required String title,
    required String content,
    required double textSize,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, bottom: 5),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.green[300] : Colors.black45,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Colors.green,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _onItemTap(index, title, content),
      ),
    );
  }
}
