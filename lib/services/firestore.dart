import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realestate_app/services/databaseHelper.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Save user data after sign-up
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? phoneNumber,
    bool? isAdmin = false,
    String? profilePictureUrl,
  }) async {
    try {
      // Step 1: Check if the user already exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        print("User already exists in Firestore.");
        return; // Stop saving duplicate user
      }

      // Step 2: Save new user data
      final userData = {
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber ?? '',
        'isAdmin': isAdmin ?? false,
        'profilePictureUrl': profilePictureUrl ?? '',
        'createdAt': Timestamp.now(),
      };

      await _firestore.collection('users').doc(userId).set(userData);

      // Sync with SQLite
      await _databaseHelper.insertOrUpdateUser({
        'id': userId,
        'name': username,
        'email': email,
        'phoneNumber': phoneNumber ?? '',
        'isAdmin': (isAdmin ?? false) ? 1 : 0,
        'profilePictureUrl': profilePictureUrl ?? '',
      });
    } catch (e) {
      throw "Failed to save user data: $e";
    }
  }


  // Fetch user data from Firestore and sync with SQLite
  Future<void> syncUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Ensure data consistency before inserting into SQLite
        await _databaseHelper.insertOrUpdateUser({
          'id': userId,
          'name': userData.containsKey('username') ? userData['username'] : '',
          'email': userData.containsKey('email') ? userData['email'] : '',
          'phoneNumber': userData.containsKey('phoneNumber') ? userData['phoneNumber'] : '',
          'isAdmin': userData.containsKey('isAdmin') && userData['isAdmin'] ? 1 : 0,
          'profilePictureUrl': userData.containsKey('profilePictureUrl') ? userData['profilePictureUrl'] : '',
        });
      } else {
        throw "User data not found in Firestore";
      }
    } catch (e) {
      throw "Failed to sync user data: $e";
    }
  }


  // Update user data in Firestore and SQLite
  Future<void> updateUserData({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);

      // Sync with SQLite
      await _databaseHelper.updateUser({
        'id': userId,
        'name': data.containsKey('username') ? data['username'] : '',
        'email': data.containsKey('email') ? data['email'] : '',
        'phoneNumber': data.containsKey('phoneNumber') ? data['phoneNumber'] : '',
        'isAdmin': data.containsKey('isAdmin') && data['isAdmin'] ? 1 : 0,
        'profilePictureUrl': data.containsKey('profilePictureUrl') ? data['profilePictureUrl'] : '',
      });
    } catch (e) {
      throw "Failed to update user data: $e";
    }
  }


  // Delete user data from Firestore and SQLite
  Future<void> deleteUserData(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();

      // Delete from SQLite
      final db = await _databaseHelper.database;
      await db.delete('users', where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw "Failed to delete user data: $e";
    }
  }
}