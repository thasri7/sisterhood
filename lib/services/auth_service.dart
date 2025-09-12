import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'user_service_no_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required int age,
    required List<String> interests,
    required String location,
    required double latitude,
    required double longitude,
    String? bio,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Create user document in Firestore
        UserModel userModel = UserModel(
          id: user.uid,
          email: email,
          name: name,
          age: age,
          interests: interests,
          location: location,
          latitude: latitude,
          longitude: longitude,
          bio: bio,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        return await getUserData(user.uid);
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    return await UserService.getUserById(uid);
  }

  // Update user data
  Future<void> updateUserData(UserModel user) async {
    await UserService.updateUser(user);
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      }
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  // Update last active time
  Future<void> updateLastActive() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastActive': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      // Silent fail for last active update
    }
  }
}
