import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  List<XFile> _images = [];

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
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = _nameController.text;
    request.fields['phone'] = _phoneController.text;
    request.fields['category'] = _categoryController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['location'] = _addressController.text;

    for (var image in _images) {
      request.files
          .add(await http.MultipartFile.fromPath('images', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
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
        SnackBar(
            content: Text('Error updating profile: ${response.reasonPhrase}')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles;
      });
    }
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
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10),
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
                          SizedBox(width: 20),
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
                      SizedBox(height: 10),
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                            ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
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
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: updateProfile,
                        child: Text(
                          'Upload photo',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                child: Text(
                  'Update Profile',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _images.isNotEmpty
                  ? Column(
                      children: _images.map((image) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.file(File(image.path)),
                        );
                      }).toList(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfileScreen(
      userName: "John Doe",
      userPhone: "123456789",
      userCategory: "Service",
      userDescription: "A professional service provider.",
      userAddress: "123 Street, City",
    ),
  ));
}
