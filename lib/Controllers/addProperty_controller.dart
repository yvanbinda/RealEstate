import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPropertyController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var properties = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  void fetchProperties() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("properties").get();
      properties.assignAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
    } catch (e) {
      print("Error fetching properties: $e");
    }
  }

  // Property Fields
  var selectedPropertyType = RxnString(null);
  var title = ''.obs;
  var address = ''.obs;
  var description = ''.obs;
  var propertyPrice = ''.obs;
  var bedrooms = 0.obs;
  var bathrooms = 0.obs;
  var galleryImages = <File>[].obs;

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
  Future<void> publishProperty() async {
    if (title.value.isEmpty ||
        address.value.isEmpty ||
        propertyPrice.value.isEmpty ||
        description.value.isEmpty ||
        selectedPropertyType.value == null) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Upload images and get URLs
      List<String> imageUrls = await uploadImagesToFirebase();

      // ✅ Fix: Ensure at least one image is uploaded before saving to Firestore
      if (imageUrls.isEmpty) {
        Get.back();
        Get.snackbar("Error", "You must upload at least one image", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Save property details to Firestore
      await _firestore.collection("properties").add({
        "title": title.value,
        "address": address.value,
        "propertyPrice": propertyPrice.value,
        "description": description.value,
        "propertyType": selectedPropertyType.value,
        "bedrooms": bedrooms.value,
        "bathrooms": bathrooms.value,
        "images": imageUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.back();
      Get.snackbar("Success", "Property Added Successfully", backgroundColor: Colors.green, colorText: Colors.white);

      // Reset fields
      title.value = "";
      address.value = "";
      propertyPrice.value = "";
      description.value = "";
      bedrooms.value = 0;
      bathrooms.value = 0;
      selectedPropertyType.value = null;
      galleryImages.clear();

      // Close the page
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar("Error", "Failed to add property: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
