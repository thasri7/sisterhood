import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/event_model.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

class EventService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Create a new event
  static Future<String?> createEvent(EventModel event) async {
    try {
      DocumentReference docRef = await _firestore.collection('events').add(event.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  // Get event by ID
  static Future<EventModel?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('events').doc(eventId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return EventModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting event: $e');
      return null;
    }
  }

  // Get upcoming events
  static Future<List<EventModel>> getUpcomingEvents({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
  }) async {
    try {
      DateTime now = DateTime.now();
      
      double latRange = radiusKm / 111.0;
      double lngRange = radiusKm / (111.0 * cos(latitude * pi / 180));

      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('latitude', isGreaterThanOrEqualTo: latitude - latRange)
          .where('latitude', isLessThanOrEqualTo: latitude + latRange)
          .where('longitude', isGreaterThanOrEqualTo: longitude - lngRange)
          .where('longitude', isLessThanOrEqualTo: longitude + lngRange)
          .where('startTime', isGreaterThan: now)
          .where('isPrivate', isEqualTo: false)
          .orderBy('startTime')
          .limit(limit)
          .get();

      List<EventModel> events = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        EventModel event = EventModel.fromMap(data);
        
        // Filter by exact distance
        double distance = _calculateDistance(
          latitude, longitude,
          event.latitude, event.longitude,
        );
        
        if (distance <= radiusKm) {
          events.add(event);
        }
      }

      return events;
    } catch (e) {
      print('Error getting upcoming events: $e');
      return [];
    }
  }

  // Get events by group
  static Future<List<EventModel>> getEventsByGroup(String groupId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('groupId', isEqualTo: groupId)
          .orderBy('startTime')
          .get();

      List<EventModel> events = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        events.add(EventModel.fromMap(data));
      }

      return events;
    } catch (e) {
      print('Error getting events by group: $e');
      return [];
    }
  }

  // Join event
  static Future<bool> joinEvent(String eventId, String userId) async {
    try {
      DocumentReference eventRef = _firestore.collection('events').doc(eventId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot eventDoc = await transaction.get(eventRef);
        
        if (!eventDoc.exists) {
          throw Exception('Event does not exist');
        }

        EventModel event = EventModel.fromMap(eventDoc.data() as Map<String, dynamic>);
        
        if (event.attendees.contains(userId)) {
          throw Exception('User already attending event');
        }

        if (event.attendees.length >= event.maxAttendees) {
          // Add to waitlist
          transaction.update(eventRef, {
            'waitlist': FieldValue.arrayUnion([userId]),
          });
        } else {
          // Add to attendees
          transaction.update(eventRef, {
            'attendees': FieldValue.arrayUnion([userId]),
          });
        }
      });

      return true;
    } catch (e) {
      print('Error joining event: $e');
      return false;
    }
  }

  // Leave event
  static Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      DocumentReference eventRef = _firestore.collection('events').doc(eventId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot eventDoc = await transaction.get(eventRef);
        
        if (!eventDoc.exists) {
          throw Exception('Event does not exist');
        }

        EventModel event = EventModel.fromMap(eventDoc.data() as Map<String, dynamic>);
        
        // Remove from attendees
        transaction.update(eventRef, {
          'attendees': FieldValue.arrayRemove([userId]),
        });

        // Remove from waitlist
        transaction.update(eventRef, {
          'waitlist': FieldValue.arrayRemove([userId]),
        });

        // If there's space and people on waitlist, move someone from waitlist to attendees
        if (event.attendees.length < event.maxAttendees && event.waitlist.isNotEmpty) {
          String nextInLine = event.waitlist.first;
          transaction.update(eventRef, {
            'attendees': FieldValue.arrayUnion([nextInLine]),
            'waitlist': FieldValue.arrayRemove([nextInLine]),
          });
        }
      });

      return true;
    } catch (e) {
      print('Error leaving event: $e');
      return false;
    }
  }

  // Get user's events
  static Future<List<EventModel>> getUserEvents(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('attendees', arrayContains: userId)
          .orderBy('startTime')
          .get();

      List<EventModel> events = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        events.add(EventModel.fromMap(data));
      }

      return events;
    } catch (e) {
      print('Error getting user events: $e');
      return [];
    }
  }

  // Store event image locally
  static Future<String?> storeEventImageLocally(String eventId, File imageFile) async {
    try {
      return await StorageService.storeProfileImage(imageFile);
    } catch (e) {
      print('Error storing event image: $e');
      return null;
    }
  }

  // Update event
  static Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  // Delete event
  static Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  // Search events
  static Future<List<EventModel>> searchEvents({
    required String query,
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
  }) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
          .where('isPrivate', isEqualTo: false)
          .limit(limit)
          .get();

      List<EventModel> events = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        EventModel event = EventModel.fromMap(data);
        
        // Filter by distance
        double distance = _calculateDistance(
          latitude, longitude,
          event.latitude, event.longitude,
        );
        
        if (distance <= radiusKm) {
          events.add(event);
        }
      }

      return events;
    } catch (e) {
      print('Error searching events: $e');
      return [];
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
