import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/user.jpg'), // Placeholder image
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('My contacts'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('To-day Live'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Market Place'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Dayli Use'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Collaborators'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('About AaramBD'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Divider(
            color: Colors.black,
            height: 10,
          ),
        ],
      ),
    );
  }
}
