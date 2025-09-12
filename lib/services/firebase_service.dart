import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Enable offline persistence
  static Future<void> enableOfflinePersistence() async {
    // Enable persistence for web, use Settings.persistenceEnabled for other platforms
    try {
      await firestore.enablePersistence();
    } catch (e) {
      // For non-web platforms, persistence is enabled by default
      print('Persistence enabled by default for this platform');
    }
  }

  // Configure Firestore settings
  static void configureFirestore() {
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
