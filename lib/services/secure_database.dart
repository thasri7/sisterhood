import 'dart:convert';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import '../models/message_model.dart';

class SecureDatabase {
  static late Box<UserModel> _userBox;
  static late Box<GroupModel> _groupBox;
  static late Box<EventModel> _eventBox;
  static late Box<MessageModel> _messageBox;
  static late Box<String> _settingsBox;
  
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static late Encrypter _encrypter;
  static late IV _iv;

  // Initialize secure database
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Generate or retrieve encryption key
    String? encryptionKey = await _secureStorage.read(key: 'db_encryption_key');
    if (encryptionKey == null) {
      encryptionKey = _generateEncryptionKey();
      await _secureStorage.write(key: 'db_encryption_key', value: encryptionKey);
    }
    
    // Initialize encryption
    final key = Key.fromBase64(encryptionKey);
    _encrypter = Encrypter(AES(key));
    _iv = IV.fromLength(16);
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(GroupModelAdapter());
    Hive.registerAdapter(EventModelAdapter());
    Hive.registerAdapter(MessageModelAdapter());
    
    // Open encrypted boxes
    _userBox = await Hive.openBox<UserModel>('users', 
      encryptionCipher: HiveAesCipher(key));
    _groupBox = await Hive.openBox<GroupModel>('groups',
      encryptionCipher: HiveAesCipher(key));
    _eventBox = await Hive.openBox<EventModel>('events',
      encryptionCipher: HiveAesCipher(key));
    _messageBox = await Hive.openBox<MessageModel>('messages',
      encryptionCipher: HiveAesCipher(key));
    _settingsBox = await Hive.openBox<String>('settings',
      encryptionCipher: HiveAesCipher(key));
  }

  // Generate secure encryption key
  static String _generateEncryptionKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  // Encrypt sensitive data
  static String _encrypt(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64;
  }

  // Decrypt sensitive data
  static String _decrypt(String encryptedData) {
    return _encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: _iv);
  }

  // User operations
  static Future<void> saveUser(UserModel user) async {
    await _userBox.put(user.id, user);
  }

  static Future<UserModel?> getUser(String userId) async {
    return _userBox.get(userId);
  }

  static Future<List<UserModel>> getAllUsers() async {
    return _userBox.values.toList();
  }

  static Future<void> deleteUser(String userId) async {
    await _userBox.delete(userId);
  }

  // Group operations
  static Future<void> saveGroup(GroupModel group) async {
    await _groupBox.put(group.id, group);
  }

  static Future<GroupModel?> getGroup(String groupId) async {
    return _groupBox.get(groupId);
  }

  static Future<List<GroupModel>> getAllGroups() async {
    return _groupBox.values.toList();
  }

  static Future<void> deleteGroup(String groupId) async {
    await _groupBox.delete(groupId);
  }

  // Event operations
  static Future<void> saveEvent(EventModel event) async {
    await _eventBox.put(event.id, event);
  }

  static Future<EventModel?> getEvent(String eventId) async {
    return _eventBox.get(eventId);
  }

  static Future<List<EventModel>> getAllEvents() async {
    return _eventBox.values.toList();
  }

  static Future<void> deleteEvent(String eventId) async {
    await _eventBox.delete(eventId);
  }

  // Message operations
  static Future<void> saveMessage(MessageModel message) async {
    await _messageBox.put(message.id, message);
  }

  static Future<List<MessageModel>> getMessages(String groupId) async {
    return _messageBox.values
        .where((message) => message.groupId == groupId)
        .toList();
  }

  static Future<void> deleteMessage(String messageId) async {
    await _messageBox.delete(messageId);
  }

  // Settings operations
  static Future<void> saveSetting(String key, String value) async {
    await _settingsBox.put(key, _encrypt(value));
  }

  static Future<String?> getSetting(String key) async {
    final encryptedValue = _settingsBox.get(key);
    if (encryptedValue != null) {
      return _decrypt(encryptedValue);
    }
    return null;
  }

  // Security operations
  static Future<void> clearAllData() async {
    await _userBox.clear();
    await _groupBox.clear();
    await _eventBox.clear();
    await _messageBox.clear();
    await _settingsBox.clear();
  }

  static Future<void> close() async {
    await _userBox.close();
    await _groupBox.close();
    await _eventBox.close();
    await _messageBox.close();
    await _settingsBox.close();
  }
}
