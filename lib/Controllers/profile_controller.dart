import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Pages/HomePage.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final isLoading = false.obs;
  RxString profilePictureUrl = ''.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString username = ''.obs; // Observable for username

  String get userId => _auth.currentUser?.uid ?? "";
  late bool isAdmin;

  /// Pick Profile Picture from Gallery
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      Get.snackbar('Error', 'No image selected.');
      return;
    }

    // Store selected image
    selectedImage.value = File(image.path);
  }

  // Upload Profile Picture to Firebase Storage
  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      String filePath = "profile_pictures/$userId.jpg";
      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);

      // Show progress while uploading
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await _firestore.collection('users').doc(userId).set({
        'profilePictureUrl': downloadUrl,
      }, SetOptions(merge: true));

      profilePictureUrl.value = downloadUrl;
      Get.back();
      Get.snackbar('Success', 'Profile picture updated!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);

      return downloadUrl; // Return the URL
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to upload profile picture: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }

  // Save Profile Information (After Uploading Picture)
  Future<void> saveProfile(String username, String phone, bool isAdmin) async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Upload profile picture if a new one is selected
      String? imageUrl = profilePictureUrl.value; // Use existing image if no new one is selected
      if (selectedImage.value != null) {
        String? uploadedUrl = await uploadProfilePicture(selectedImage.value!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      // Save profile details in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': user.email,
        'phoneNumber': phone,
        'isAdmin': isAdmin,
        'profilePictureUrl': imageUrl,
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true));

      print("_____________Username saved+________: ${this.username.value}");
      // Update observables
      this.username.value = username; // Update username observable
      profilePictureUrl.value = imageUrl;
      isLoading.value = false;

      // Navigate to HomePage
      Get.offAll(() => HomePage());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to save profile: $e');
    }
  }

  // Load User Profile from Firestore
  Future<void> loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        profilePictureUrl.value = userDoc['profilePictureUrl'] ?? '';
        username.value = userDoc['username'] ?? '';

        print("_________________________Username loaded--------------: ${username.value}");
      }
    }
  }
}
