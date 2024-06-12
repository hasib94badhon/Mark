import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String userCategory;
  final String userDescription;
  final String userAddress;

  EditProfileScreen({
    required this.userName,
    required this.userPhone,
    required this.userCategory,
    required this.userDescription,
    required this.userAddress,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _phoneController.text = widget.userPhone;
    _categoryController.text = widget.userCategory;
    _descriptionController.text = widget.userDescription;
    _addressController.text = widget.userAddress;
  }

  Future<void> updateProfile() async {
    // Add your API call here to update the profile information
    print('Name: ${_nameController.text}');
    print('Phone: ${_phoneController.text}');
    print('Category: ${_categoryController.text}');
    print('Description: ${_descriptionController.text}');
    print('Address: ${_addressController.text}');
    // Send the updated data to your backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
