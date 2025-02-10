import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Pages/services/firestore.dart';

import '../Pages/HomePage.dart';

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final User user = FirebaseAuth.instance.currentUser!;

  final RxBool isLoading = false.obs;

  Future<void> saveProfile(String username) async {
    try {
      isLoading.value = true;
      await _firestoreService.saveProfileData(
        userId: user.uid,
        username: username,
        email: user.email!,
      );

      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}