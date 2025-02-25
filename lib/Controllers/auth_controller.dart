import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realestate_app/services/firestore.dart';

import '../Authentication/login/login.dart';
import '../Authentication/signup/complete_profile.dart';
import '../Pages/HomePage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = true.obs;

  final Rx<User?> _user = Rx<User?>(null);
  final Rx<bool?> isAdmin = Rx<bool?>(null);
  User? get user => _user.value;

  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges().map((user) {
      isLoading.value = false;
      return user;
    }));
    super.onInit();
  }

  Future<void> signUp(String email, String password) async {
    try {
      // Check if email already exists
      QuerySnapshot existingUsers = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        Get.snackbar('Error', 'This email is already registered.');
        return;
      }

      // Create Firebase user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestoreService.saveUserData(
          userId: userCredential.user!.uid,
          email: email,
          username: '',
        );

        // Redirect to CompleteProfile instead of Login
        Get.offAll(() => CompleteProfile());
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException Code: ${e.code}");

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'weak-password':
          errorMessage = 'The password must be at least 6 characters.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = e.message ?? 'An unknown error occurred';
      }

      Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Unexpected error: $e");
      Get.snackbar('Error', 'Something went wrong: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await checkProfileCompletion(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    }
  }

  Future<void> checkProfileCompletion(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Ensure username & phone number are not empty
        if (userData['username'] != null && userData['username'].toString().trim().isNotEmpty &&
            userData['phoneNumber'] != null && userData['phoneNumber'].toString().trim().isNotEmpty) {
          Get.offAll(() => HomePage()); // Profile complete
        } else {
          Get.offAll(() => CompleteProfile()); // Profile incomplete
        }
      } else {
        Get.offAll(() => CompleteProfile()); // No user data found
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check profile completion: $e');
    }
  }

  Future<void> checkIfAdmin(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        isAdmin.value = userData.containsKey('isAdmin') ? userData['isAdmin'] as bool : false;
      } else {
        isAdmin.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user role: $e');
      isAdmin.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    isAdmin.value = null;
    isLoading.value = true;
    Get.offAll(() => Login());
  }
}
