import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PostUpload extends StatefulWidget {
  final String postName;
  final String postPhone;
  final String postCategory;
  final String postDescription;

  PostUpload({
    required this.postName,
    required this.postPhone,
    required this.postCategory,
    required this.postDescription,
  });

  @override
  _PostUploadState createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload> {
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = true;
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.postDescription;
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

  Future<void> postAd() async {
    final url = 'http://192.168.0.103:5000/post_data';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['post_phone'] = widget.postPhone;
    request.fields['post_cat'] = widget.postCategory;
    request.fields['description'] = _descriptionController.text;

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath('media', image.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully')),
        );
        Navigator.pop(context, true); // Indicate the post was created
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post data: ${data["message"]}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting data: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Ads.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Upload Images'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: postAd,
                child: Text('POST'),
              ),
              SizedBox(height: 20),
              _images.isNotEmpty
                  ? Column(
                      children: _images.map((image) {
                        return Image.file(File(image.path));
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
