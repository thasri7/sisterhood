import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/message_model.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

class MessagingService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Send a text message
  static Future<String?> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? groupId,
  }) async {
    try {
      MessageModel message = MessageModel(
        id: '',
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
        groupId: groupId,
      );

      DocumentReference docRef = await _firestore.collection('messages').add(message.toMap());
      
      // Update the message with its ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  // Send an image message
  static Future<String?> sendImageMessage({
    required String senderId,
    required String receiverId,
    required File imageFile,
    String? groupId,
  }) async {
    try {
      // Store image locally
      String? imageData = await StorageService.storeProfileImage(imageFile);
      if (imageData == null) return null;

      MessageModel message = MessageModel(
        id: '',
        senderId: senderId,
        receiverId: receiverId,
        content: 'Image',
        type: MessageType.image,
        timestamp: DateTime.now(),
        imageUrl: imageData,
        groupId: groupId,
      );

      DocumentReference docRef = await _firestore.collection('messages').add(message.toMap());
      
      // Update the message with its ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      print('Error sending image message: $e');
      return null;
    }
  }

  // Get messages between two users
  static Stream<List<MessageModel>> getMessages({
    required String currentUserId,
    required String otherUserId,
    int limit = 50,
  }) {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: currentUserId)
        .where('receiverId', isEqualTo: otherUserId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      List<MessageModel> messages = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        messages.add(MessageModel.fromMap(data));
      }
      return messages.reversed.toList();
    });
  }

  // Get group messages
  static Stream<List<MessageModel>> getGroupMessages({
    required String groupId,
    int limit = 50,
  }) {
    return _firestore
        .collection('messages')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      List<MessageModel> messages = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        messages.add(MessageModel.fromMap(data));
      }
      return messages.reversed.toList();
    });
  }

  // Mark message as read
  static Future<void> markMessageAsRead(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  // Get unread message count
  static Stream<int> getUnreadMessageCount(String userId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Get recent conversations
  static Stream<List<Map<String, dynamic>>> getRecentConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> conversations = [];
      for (DocumentSnapshot doc in snapshot.docs) {
        conversations.add(doc.data() as Map<String, dynamic>);
      }
      return conversations;
    });
  }

  // Create or update conversation
  static Future<void> updateConversation({
    required String currentUserId,
    required String otherUserId,
    required String lastMessage,
    required DateTime timestamp,
    String? groupId,
  }) async {
    try {
      String conversationId = groupId ?? '${currentUserId}_$otherUserId';
      
      await _firestore.collection('conversations').doc(conversationId).set({
        'id': conversationId,
        'participants': [currentUserId, otherUserId],
        'lastMessage': lastMessage,
        'lastMessageTime': timestamp,
        'groupId': groupId,
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating conversation: $e');
    }
  }


  // Delete message
  static Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).delete();
    } catch (e) {
      print('Error deleting message: $e');
      rethrow;
    }
  }

  // Block user from messaging
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

  // Report message
  static Future<void> reportMessage(String messageId, String reporterId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'messageId': messageId,
        'reporterId': reporterId,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error reporting message: $e');
      rethrow;
    }
  }
}
