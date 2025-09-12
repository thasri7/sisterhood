import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
      } else {
        _user = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> signUp({
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
      _isLoading = true;
      notifyListeners();

      _user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        age: age,
        interests: interests,
        location: location,
        latitude: latitude,
        longitude: longitude,
        bio: bio,
      );

      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await _authService.updateUserData(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLastActive() async {
    await _authService.updateLastActive();
  }
}
