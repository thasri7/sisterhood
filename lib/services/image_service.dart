import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  // Cloudinary configuration (free tier)
  static const String _cloudName = 'your-cloud-name';
  static const String _uploadPreset = 'your-upload-preset';
  static const String _baseUrl = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  // Upload image to Cloudinary (free alternative)
  static Future<String?> uploadImage(File imageFile, {String? folder}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      
      // Add upload preset
      request.fields['upload_preset'] = _uploadPreset;
      
      // Add folder if specified
      if (folder != null) {
        request.fields['folder'] = folder;
      }
      
      // Add image file
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      
      var response = await request.send();
      
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        return jsonData['secure_url'];
      }
      
      return null;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  // Upload profile image
  static Future<String?> uploadProfileImage(String userId, File imageFile) async {
    return await uploadImage(imageFile, folder: 'sisterhood/profiles');
  }

  // Upload group image
  static Future<String?> uploadGroupImage(String groupId, File imageFile) async {
    return await uploadImage(imageFile, folder: 'sisterhood/groups');
  }

  // Upload event image
  static Future<String?> uploadEventImage(String eventId, File imageFile) async {
    return await uploadImage(imageFile, folder: 'sisterhood/events');
  }

  // Upload message image
  static Future<String?> uploadMessageImage(File imageFile) async {
    return await uploadImage(imageFile, folder: 'sisterhood/messages');
  }
}
