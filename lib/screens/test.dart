<<<<<<< HEAD

=======
import 'package:flutter/material.dart';

class UserProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black26),
              accountName: Column(
                children: [
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
                        'https://www.example.com/profile_picture.jpg', // Replace with your image URL
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Adds spacing between the profile picture and the name
                  Text(
                    "Rafiq",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height: 5), // Adds spacing between the name and the email
                  Text(
                    "dhfvbdyufvad@gmail.com",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              accountEmail: null, // Hide the default email text
            ),
          ),
          // Add other drawer items here
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Drawer Example')),
      drawer: UserProfileDrawer(),
      body: Center(child: Text('Content goes here')),
    ),
  ));
}
>>>>>>> origin/main
