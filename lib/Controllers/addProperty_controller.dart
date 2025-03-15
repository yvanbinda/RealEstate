import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPropertyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // List to store properties fetched from Firestore
  var properties = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties(); // Fetch properties when the controller is initialized
  }

  // Fetch properties from Firestore
  void fetchProperties() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("properties").get();
      properties.assignAll(snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id, // Include the document ID for reference
        };
      }).toList());
    } catch (e) {
      print("Error fetching properties: $e");
      Get.snackbar("Error", "Failed to fetch properties: $e");
    }
  }

  // TextEditingControllers for form fields
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final propertyPriceController = TextEditingController();
  final descriptionController = TextEditingController();

  // Property Fields
  RxString selectedPropertyType = ''.obs;
  final propertyTypes = ["House", "Apartment", "Studio", "Room", "Meubler"].obs;
  var galleryImages = <File>[].obs;

  // Clear all controllers
  void clearControllers() {
    titleController.clear();
    addressController.clear();
    bedroomController.clear();
    bathroomController.clear();
    propertyPriceController.clear();
    descriptionController.clear();
    selectedPropertyType.value = '';
    galleryImages.clear();
  }

  // Pick images (Clears previous selection before picking new ones)
  Future<void> pickGalleryImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      galleryImages.clear();
      galleryImages.addAll(result.files.map((file) => File(file.path!)));
    }
  }

  // Upload images to Firebase Storage and return URLs
  Future<List<String>> uploadImagesToFirebase() async {
    List<String> imageUrls = [];

    for (var image in galleryImages) {
      try {
        String fileName = "properties/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}";
        Reference ref = _storage.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(image);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return imageUrls;
  }

  // Publish Property to Firestore
  Future<void> publishProperty({
    required String title,
    required String address,
    required String propertyPrice,
    required String description,
    required String bedroom,
    required String bathroom,
  }) async {
    // Validate required fields
    if (title.isEmpty ||
        address.isEmpty ||
        propertyPrice.isEmpty ||
        description.isEmpty ||
        bedroom.isEmpty ||
        bathroom.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading dialog
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Upload images and get URLs
      List<String> imageUrls = await uploadImagesToFirebase();

      // Save property details to Firestore
      await _firestore.collection("properties").add({
        "title": title,
        "address": address,
        "propertyPrice": propertyPrice,
        "description": description,
        "propertyType": selectedPropertyType.value,
        "bedrooms": int.tryParse(bedroom) ?? 0,
        "bathrooms": int.tryParse(bathroom) ?? 0,
        "images": imageUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        "Success",
        "Property Added Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear controllers and reset fields
      clearControllers();

      // Fetch updated properties list
      fetchProperties();

      // Close the page after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        Get.back();
      });
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error message
      Get.snackbar(
        "Error",
        "Failed to add property: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Update property
  Future<void> updateProperty({
    required String id,
    required String title,
    required String address,
    required String propertyPrice,
    required String description,
    required String bedroom,
    required String bathroom,
  }) async {
    // Validate required fields
    if (title.isEmpty ||
        address.isEmpty ||
        propertyPrice.isEmpty ||
        description.isEmpty ||
        bedroom.isEmpty ||
        bathroom.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    // Show loading dialog
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Upload images and get URLs (if new images are added)
      List<String> imageUrls = await uploadImagesToFirebase();

      // Update property details in Firestore
      await _firestore.collection("properties").doc(id).update({
        "title": title,
        "address": address,
        "propertyPrice": propertyPrice,
        "description": description,
        "propertyType": selectedPropertyType.value,
        "bedrooms": int.tryParse(bedroom) ?? 0,
        "bathrooms": int.tryParse(bathroom) ?? 0,
        "images": imageUrls.isNotEmpty ? imageUrls : FieldValue.delete(), // Update images if new ones are added
      });

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar("Success", "Property Updated Successfully");

      // Clear controllers and reset fields
      clearControllers();

      // Fetch updated properties list
      fetchProperties();

      // Close the page after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        Get.back();
      });
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error message
      Get.snackbar("Error", "Failed to update property: $e");
    }
  }
}