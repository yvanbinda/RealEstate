import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data after sign-up
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      throw "Failed to save user data: $e";
    }
  }

  // Save user profile data
  Future<void> saveProfileData({
    required String userId,
    required String username,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'createdAt': DateTime.now(),
      }, SetOptions(merge: true)); // Merge with existing data
    } catch (e) {
      throw "Failed to save profile data: $e";
    }
  }

  // Fetch user data
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        throw "User data not found";
      }
    } catch (e) {
      throw "Failed to fetch user data: $e";
    }
  }

  // Update user data
  Future<void> updateUserData({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw "Failed to update user data: $e";
    }
  }

  // Delete user data
  Future<void> deleteUserData(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw "Failed to delete user data: $e";
    }
  }
}