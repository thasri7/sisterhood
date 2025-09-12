import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // Store user data locally
  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(userData));
  }

  // Get user data from local storage
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // Store profile image locally (base64)
  static Future<String?> storeProfileImage(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', base64Image);
      
      return base64Image;
    } catch (e) {
      print('Error storing profile image: $e');
      return null;
    }
  }

  // Get profile image from local storage
  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }

  // Store app settings
  static Future<void> storeSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', json.encode(settings));
  }

  // Get app settings
  static Future<Map<String, dynamic>?> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? settingsString = prefs.getString('app_settings');
    if (settingsString != null) {
      return json.decode(settingsString);
    }
    return null;
  }

  // Clear all local data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
