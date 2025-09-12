# Firebase Setup Guide for Sisterhood App

## 🚀 Quick Setup Steps

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `sisterhood-app` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2. Add Android App
1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.example.sisterhood_app`
3. Download `google-services.json`
4. Place it in `android/app/` directory

### 3. Add iOS App
1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID: `com.example.sisterhoodApp`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### 4. Enable Firebase Services

#### Authentication
1. Go to Authentication → Sign-in method
2. Enable "Email/Password"
3. Enable "Anonymous" (optional)

#### Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users

#### Storage (Optional - Requires Paid Plan)
**Option A: Enable Firebase Storage (Recommended)**
1. Go to Storage
2. Click "Upgrade project" to Blaze plan
3. Set spending limits ($1-5 daily, $10-20 monthly)
4. Choose "Start in test mode" (for development)
5. Select same location as Firestore

**Option B: Use Free Alternative (Cloudinary)**
1. Sign up at [Cloudinary](https://cloudinary.com/) (free tier)
2. Get your cloud name and upload preset
3. Update `lib/services/image_service.dart` with your credentials
4. The app will use Cloudinary instead of Firebase Storage

**Option C: Local Storage Only**
1. Skip Firebase Storage setup
2. Images will be stored locally on device
3. Update services to use `storage_service.dart`

### 5. Update Firebase Configuration

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-messaging-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-actual-project-id.firebaseapp.com',
  storageBucket: 'your-actual-project-id.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-messaging-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-actual-ios-api-key',
  appId: 'your-actual-ios-app-id',
  messagingSenderId: 'your-actual-messaging-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
  iosBundleId: 'com.example.sisterhoodApp',
);
```

### 6. Security Rules (Production)

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Groups - members can read, creators can write
    match /groups/{groupId} {
      allow read: if request.auth != null && 
        (resource.data.members[request.auth.uid] != null || 
         resource.data.createdBy == request.auth.uid);
      allow write: if request.auth != null && 
        resource.data.createdBy == request.auth.uid;
    }
    
    // Events - similar to groups
    match /events/{eventId} {
      allow read: if request.auth != null && 
        (resource.data.attendees[request.auth.uid] != null || 
         resource.data.createdBy == request.auth.uid);
      allow write: if request.auth != null && 
        resource.data.createdBy == request.auth.uid;
    }
    
    // Messages - participants can read/write
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (resource.data.senderId == request.auth.uid || 
         resource.data.receiverId == request.auth.uid);
    }
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_images/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    match /group_images/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    match /event_images/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    match /message_images/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 7. Test the Setup

Run the app:
```bash
flutter run
```

The app should now:
- ✅ Connect to Firebase
- ✅ Allow user registration/login
- ✅ Store user data in Firestore
- ✅ Upload images to Storage
- ✅ Work offline with cached data

### 8. Production Considerations

1. **Security Rules**: Update Firestore and Storage rules for production
2. **Authentication**: Add additional sign-in methods (Google, Apple)
3. **Push Notifications**: Set up FCM for real-time notifications
4. **Analytics**: Enable Firebase Analytics for user insights
5. **Crashlytics**: Add Firebase Crashlytics for error tracking
6. **Performance**: Enable Firebase Performance Monitoring

### 9. Troubleshooting

#### Common Issues:
- **Build errors**: Make sure `google-services.json` and `GoogleService-Info.plist` are in correct locations
- **Permission errors**: Check Firestore/Storage security rules
- **Network errors**: Verify Firebase project configuration
- **Authentication errors**: Ensure Email/Password is enabled in Firebase Console

#### Debug Commands:
```bash
flutter clean
flutter pub get
flutter run --verbose
```

### 10. Next Steps

Once Firebase is set up, the app will have:
- ✅ Real user authentication
- ✅ User profiles with images
- ✅ Location-based discovery
- ✅ Groups and events
- ✅ Real-time messaging
- ✅ Image uploads
- ✅ Offline support

The app is now ready for real-world use! 🎉
