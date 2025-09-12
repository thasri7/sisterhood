import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/group_model.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

class GroupService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Create a new group
  static Future<String?> createGroup(GroupModel group) async {
    try {
      DocumentReference docRef = await _firestore.collection('groups').add(group.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating group: $e');
      return null;
    }
  }

  // Get group by ID
  static Future<GroupModel?> getGroupById(String groupId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('groups').doc(groupId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return GroupModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting group: $e');
      return null;
    }
  }

  // Get groups by category
  static Future<List<GroupModel>> getGroupsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groups')
          .where('category', isEqualTo: category)
          .where('isPrivate', isEqualTo: false)
          .orderBy('lastActivity', descending: true)
          .limit(20)
          .get();

      List<GroupModel> groups = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        groups.add(GroupModel.fromMap(data));
      }

      return groups;
    } catch (e) {
      print('Error getting groups by category: $e');
      return [];
    }
  }

  // Get nearby groups
  static Future<List<GroupModel>> getNearbyGroups({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
  }) async {
    try {
      double latRange = radiusKm / 111.0;
      double lngRange = radiusKm / (111.0 * cos(latitude * pi / 180));

      QuerySnapshot snapshot = await _firestore
          .collection('groups')
          .where('latitude', isGreaterThanOrEqualTo: latitude - latRange)
          .where('latitude', isLessThanOrEqualTo: latitude + latRange)
          .where('longitude', isGreaterThanOrEqualTo: longitude - lngRange)
          .where('longitude', isLessThanOrEqualTo: longitude + lngRange)
          .where('isPrivate', isEqualTo: false)
          .orderBy('lastActivity', descending: true)
          .limit(limit)
          .get();

      List<GroupModel> groups = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        GroupModel group = GroupModel.fromMap(data);
        
        // Filter by exact distance
        double distance = _calculateDistance(
          latitude, longitude,
          group.latitude, group.longitude,
        );
        
        if (distance <= radiusKm) {
          groups.add(group);
        }
      }

      return groups;
    } catch (e) {
      print('Error getting nearby groups: $e');
      return [];
    }
  }

  // Join group
  static Future<bool> joinGroup(String groupId, String userId) async {
    try {
      DocumentReference groupRef = _firestore.collection('groups').doc(groupId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot groupDoc = await transaction.get(groupRef);
        
        if (!groupDoc.exists) {
          throw Exception('Group does not exist');
        }

        GroupModel group = GroupModel.fromMap(groupDoc.data() as Map<String, dynamic>);
        
        if (group.members.contains(userId)) {
          throw Exception('User already in group');
        }

        if (group.members.length >= group.maxMembers) {
          throw Exception('Group is full');
        }

        transaction.update(groupRef, {
          'members': FieldValue.arrayUnion([userId]),
          'lastActivity': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error joining group: $e');
      return false;
    }
  }

  // Leave group
  static Future<bool> leaveGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([userId]),
        'lastActivity': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error leaving group: $e');
      return false;
    }
  }

  // Get user's groups
  static Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('groups')
          .where('members', arrayContains: userId)
          .orderBy('lastActivity', descending: true)
          .get();

      List<GroupModel> groups = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        groups.add(GroupModel.fromMap(data));
      }

      return groups;
    } catch (e) {
      print('Error getting user groups: $e');
      return [];
    }
  }

  // Store group image locally
  static Future<String?> storeGroupImageLocally(String groupId, File imageFile) async {
    try {
      return await StorageService.storeProfileImage(imageFile);
    } catch (e) {
      print('Error storing group image: $e');
      return null;
    }
  }

  // Update group
  static Future<void> updateGroup(GroupModel group) async {
    try {
      await _firestore.collection('groups').doc(group.id).update(group.toMap());
    } catch (e) {
      print('Error updating group: $e');
      rethrow;
    }
  }

  // Delete group
  static Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      print('Error deleting group: $e');
      rethrow;
    }
  }

  // Calculate distance between two points
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371;
    
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
