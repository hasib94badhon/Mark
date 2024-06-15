import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  late GoogleMapController mapController;
  LatLng _currentPosition = LatLng(23.8103, 90.4125); // Default to Dhaka

  String _selectedType = 'Service';
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _phoneController.text = widget.userPhone;
    _categoryController.text = widget.userCategory;
    _descriptionController.text = widget.userDescription;
    _addressController.text = widget.userAddress;
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.103:5000/get_categories_name'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];
      setState(() {
        _categories = categoryList.cast<String>();
        _selectedCategory = _categories.contains(widget.userCategory)
            ? widget.userCategory
            : _categories.isNotEmpty
                ? _categories[0]
                : null;
        _categoryController.text = _selectedCategory ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load categories');
    }
  }

  Future<void> updateProfile() async {
    final url = 'http://192.168.0.103:5000/update_user_profile';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'location': _addressController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true); // Indicate the profile was updated
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update profile: ${data["message"]}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${response.body}')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'Service',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  Text('Service'),
                  Radio<String>(
                    value: 'Shops',
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  Text('Shops'),
                ],
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                          _categoryController.text = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
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
              SizedBox(height: 10),
              Container(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId("current_location"),
                      position: _currentPosition,
                      draggable: true,
                      onDragEnd: (newPosition) {
                        setState(() {
                          _currentPosition = newPosition;
                          _addressController.text =
                              "${newPosition.latitude}, ${newPosition.longitude}";
                        });
                      },
                    ),
                  },
                ),
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
