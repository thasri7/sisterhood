import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _nearbyUsers = [];
  List<UserModel> _recommendedUsers = [];
  bool _isLoading = false;

  List<UserModel> get nearbyUsers => _nearbyUsers;
  List<UserModel> get recommendedUsers => _recommendedUsers;
  bool get isLoading => _isLoading;

  Future<void> loadNearbyUsers({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String currentUserId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Query users within radius
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .get();

      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Filter by distance
      _nearbyUsers = users.where((user) {
        double distance = _calculateDistance(
          latitude,
          longitude,
          user.latitude,
          user.longitude,
        );
        return distance <= radiusKm;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadRecommendedUsers({
    required String currentUserId,
    required List<String> interests,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .get();

      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Filter by common interests
      _recommendedUsers = users.where((user) {
        return user.interests.any((interest) => interests.contains(interest));
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportUser(String userId, String reportedUserId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'reportedUsers': FieldValue.arrayUnion([reportedUserId]),
      });
    } catch (e) {
      rethrow;
    }
  }
}
