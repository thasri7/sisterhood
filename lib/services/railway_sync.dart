import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import '../models/message_model.dart';
import 'secure_database.dart';

class RailwaySync {
  // Railway server URL
  static const String baseUrl = 'https://web-production-5a40.up.railway.app';
  
  // Check internet connectivity
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Sync user data
  static Future<bool> syncUser(UserModel user) async {
    try {
      if (!await isConnected()) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get users from server
  static Future<List<UserModel>> getUsersFromServer() async {
    try {
      if (!await isConnected()) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Sync group data
  static Future<bool> syncGroup(GroupModel group) async {
    try {
      if (!await isConnected()) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/api/groups'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(group.toMap()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get groups from server
  static Future<List<GroupModel>> getGroupsFromServer() async {
    try {
      if (!await isConnected()) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/groups'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GroupModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Sync event data
  static Future<bool> syncEvent(EventModel event) async {
    try {
      if (!await isConnected()) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/api/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.toMap()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get events from server
  static Future<List<EventModel>> getEventsFromServer() async {
    try {
      if (!await isConnected()) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/events'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => EventModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Sync message data
  static Future<bool> syncMessage(MessageModel message) async {
    try {
      if (!await isConnected()) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message.toMap()),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get messages from server
  static Future<List<MessageModel>> getMessagesFromServer(String groupId) async {
    try {
      if (!await isConnected()) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/$groupId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MessageModel.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Full sync - sync all local data to server
  static Future<void> fullSync() async {
    try {
      if (!await isConnected()) return;

      // Sync users
      final users = await SecureDatabase.getAllUsers();
      for (final user in users) {
        await syncUser(user);
      }

      // Sync groups
      final groups = await SecureDatabase.getAllGroups();
      for (final group in groups) {
        await syncGroup(group);
      }

      // Sync events
      final events = await SecureDatabase.getAllEvents();
      for (final event in events) {
        await syncEvent(event);
      }

      // Sync messages
      final messages = await SecureDatabase._messageBox.values.toList();
      for (final message in messages) {
        await syncMessage(message);
      }
    } catch (e) {
      // Handle sync error
    }
  }

  // Pull data from server to local
  static Future<void> pullFromServer() async {
    try {
      if (!await isConnected()) return;

      // Pull users
      final serverUsers = await getUsersFromServer();
      for (final user in serverUsers) {
        await SecureDatabase.saveUser(user);
      }

      // Pull groups
      final serverGroups = await getGroupsFromServer();
      for (final group in serverGroups) {
        await SecureDatabase.saveGroup(group);
      }

      // Pull events
      final serverEvents = await getEventsFromServer();
      for (final event in serverEvents) {
        await SecureDatabase.saveEvent(event);
      }
    } catch (e) {
      // Handle pull error
    }
  }
}
