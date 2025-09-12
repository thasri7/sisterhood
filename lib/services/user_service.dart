
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Get user by ID
  static Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Update user data
  static Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Upload profile image
  static Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      String? imageUrl = await StorageService.storeProfileImage(imageFile);
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Get nearby users
  static Future<List<UserModel>> getNearbyUsers({
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String currentUserId,
    int limit = 50,
  }) async {
    try {
      // Query users within a bounding box (approximate)
      double latRange = radiusKm / 111.0; // Rough conversion: 1 degree ≈ 111 km
      double lngRange = radiusKm / (111.0 * cos(latitude * 3.14159 / 180));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('latitude', isGreaterThanOrEqualTo: latitude - latRange)
          .where('latitude', isLessThanOrEqualTo: latitude + latRange)
          .where('longitude', isGreaterThanOrEqualTo: longitude - lngRange)
          .where('longitude', isLessThanOrEqualTo: longitude + lngRange)
          .limit(limit)
          .get();

      List<UserModel> users = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc.id != currentUserId) {
          UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          users.add(user);
        }
      }

      // Filter by exact distance
      users.removeWhere((user) {
        double distance = _calculateDistance(
          latitude, longitude,
          user.latitude, user.longitude,
        );
        return distance > radiusKm;
      });

      return users;
    } catch (e) {
      print('Error getting nearby users: $e');
      return [];
    }
  }

  // Get recommended users based on interests
  static Future<List<UserModel>> getRecommendedUsers({
    required String currentUserId,
    required List<String> interests,
    int limit = 20,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .limit(limit * 2) // Get more to filter
          .get();

      List<UserModel> users = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        
        // Check for common interests
        bool hasCommonInterests = user.interests.any((interest) => 
          interests.contains(interest));
        
        if (hasCommonInterests) {
          users.add(user);
        }
      }

      // Sort by number of common interests
      users.sort((a, b) {
        int aCommon = a.interests.where((interest) => 
          interests.contains(interest)).length;
        int bCommon = b.interests.where((interest) => 
          interests.contains(interest)).length;
        return bCommon.compareTo(aCommon);
      });

      return users.take(limit).toList();
    } catch (e) {
      print('Error getting recommended users: $e');
      return [];
    }
  }

  // Block user
  static Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
    } catch (e) {
      print('Error blocking user: $e');
      rethrow;
    }
  }

  // Report user
  static Future<void> reportUser(String userId, String reportedUserId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'reporterId': userId,
        'reportedUserId': reportedUserId,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error reporting user: $e');
      rethrow;
    }
  }

  // Update last active
  static Future<void> updateLastActive(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last active: $e');
    }
  }

  // Calculate distance between two points
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * 
        sin(dLng / 2) * sin(dLng / 2);
    
    double c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
