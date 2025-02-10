import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realestate_app/Pages/services/firestore.dart';

import '../Authentication/login/login.dart';
import '../Pages/HomePage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges()); // Listen to auth state changes
    super.onInit();
  }

  Future<void> signUp(String email, String password) async {
    try {
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

        Get.offAll(() => Login()); // Navigate to Home screen
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Get.offAll(() => HomePage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => Login());
  }
}