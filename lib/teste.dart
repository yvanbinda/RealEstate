import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PropertyInputPage(),
    );
  }
}

class PropertyInputPage extends StatefulWidget {
  @override
  _PropertyInputPageState createState() => _PropertyInputPageState();
}

class _PropertyInputPageState extends State<PropertyInputPage> {
  final _formKey = GlobalKey<FormState>();

  File? _mainImage;
  List<File> _galleryImages = [];
  String? _title, _location, _type;
  int? _bedrooms, _bathrooms;
  double? _price;
  String? _description;

  final List<String> _propertyTypes = ['Apartment', 'House', 'Villa', 'Studio'];

  // Function to pick a main image
  Future<void> _pickMainImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _mainImage = File(result.files.single.path!);
      });
    }
  }

  // Function to pick gallery images
  Future<void> _pickGalleryImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _galleryImages = result.files.map((file) => File(file.path!)).toList();
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process form data
      print("Title: $_title");
      print("Location: $_location");
      print("Type: $_type");
      print("Bedrooms: $_bedrooms");
      print("Bathrooms: $_bathrooms");
      print("Price: $_price");
      print("Description: $_description");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Add Property"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 📸 Upload Main Image
              GestureDetector(
                onTap: _pickMainImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: _mainImage == null
                      ? Center(
                    child: Text(
                      "Tap to upload main image",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_mainImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 🏡 Title Input
              _buildTextField("Title", (value) => _title = value),

              // 📍 Location Input
              _buildTextField("Location", (value) => _location = value),

              // 🏢 Property Type Dropdown
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: Colors.grey[900],
                decoration: _inputDecoration("Property Type"),
                items: _propertyTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type, style: TextStyle(color: Colors.white))))
                    .toList(),
                onChanged: (value) => setState(() => _type = value),
                validator: (value) => value == null ? "Select a property type" : null,
              ),
              SizedBox(height: 20),

              // 🛏 Bedrooms Input
              _buildNumberField("Number of Bedrooms", (value) => _bedrooms = int.tryParse(value)),

              // 🚿 Bathrooms Input
              _buildNumberField("Number of Bathrooms", (value) => _bathrooms = int.tryParse(value)),

              // 💰 Price Input
              _buildNumberField("Price per Month (\$)", (value) => _price = double.tryParse(value)),

              // 📸 Upload Gallery Images
              GestureDetector(
                onTap: _pickGalleryImages,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Center(
                    child: Text(
                      "Tap to upload gallery images",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Show selected images
              _galleryImages.isNotEmpty
                  ? SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _galleryImages.map((file) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(file, width: 60, height: 60, fit: BoxFit.cover),
                    );
                  }).toList(),
                ),
              )
                  : Container(),

              SizedBox(height: 20),

              // 📝 Description Input
              _buildTextField("Description", (value) => _description = value, maxLines: 4),

              SizedBox(height: 20),

              // ✅ Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: Text("Submit Property", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget _buildTextField(String label, Function(String) onSaved, {int maxLines = 1}) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      onSaved: (value) => onSaved(value!),
      maxLines: maxLines,
    );
  }

  // Reusable number input field
  Widget _buildNumberField(String label, Function(String) onSaved) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: (value) => value!.isEmpty ? "Enter $label" : null,
      onSaved: (value) => onSaved(value!),
    );
  }

  // Input field decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    );
  }
}
