import 'package:aaram_bd/widgets/FloatingPage.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = -1;

  void _onItemTap(int index, String title, String content) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FloatingPage(title: title, content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black26,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black26),
              accountName: Text(
                "Rafiq",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "dhfvbdyufvad@gmail.com",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Daily Use',
            index: 0,
            title: 'Daily Use',
            content: 'Content for Daily Use',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Social Market',
            index: 1,
            title: 'Social Market',
            content: 'Content for Social Market',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'To-day Live',
            index: 2,
            title: 'To-day Live',
            content: 'Content for To-day Live',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'My Contacts',
            index: 3,
            title: 'My Contacts',
            content: 'Content for My Contacts',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Emergency Contacts',
            index: 4,
            title: 'Emergency Contacts',
            content: 'Content for Emergency Contacts',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Business',
            index: 5,
            title: 'Business',
            content: 'Content for Business',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Collaborators',
            index: 6,
            title: 'Collaborators',
            content: 'Content for Collaborators',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Contact AaramBD',
            index: 7,
            title: 'Contact AaramBD',
            content: 'Content for Contact AaramBD',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Terms and policies',
            index: 8,
            title: 'Terms and policies',
            content: 'Content for Terms and policies',
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'More',
            index: 9,
            title: 'More',
            content: 'Content for More',
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
  }) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, bottom: 5),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.green : Colors.white,
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
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _onItemTap(index, title, content),
      ),
    );
  }
}
