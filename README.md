# Sisterhood - Local Women's Community App

A Flutter app that connects women in local communities for friendship, support, and shared activities.

## Features

- **User Authentication**: Secure sign-up and sign-in with Firebase
- **Profile Management**: Create and manage user profiles with interests and location
- **Local Discovery**: Find women nearby with similar interests
- **Groups**: Join and create interest-based groups
- **Events**: Discover and attend local events
- **Safety Features**: Block and report users, verified profiles

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **Maps**: Google Maps API
- **Location**: Geolocator

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account

### 2. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password)
3. Enable Firestore Database
4. Enable Storage
5. Add your app to the Firebase project:
   - For Android: Add Android app and download `google-services.json`
   - For iOS: Add iOS app and download `GoogleService-Info.plist`

### 3. Configure Firebase

1. Update `lib/firebase_options.dart` with your Firebase configuration:
   - Replace placeholder values with your actual Firebase project details
   - Get these values from Firebase Console > Project Settings > General

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── models/           # Data models (User, Group, Event)
├── screens/          # UI screens
│   ├── auth/        # Authentication screens
│   └── home/        # Main app screens
├── providers/        # State management
├── services/         # Business logic services
├── widgets/          # Reusable UI components
└── utils/           # Utility functions
```

## Key Features Implementation

### Authentication
- Email/password sign-up and sign-in
- User profile creation with interests and location
- Secure user data storage in Firestore

### Location Services
- GPS-based user location
- Distance calculation between users
- Location-based user discovery

### Safety Features
- User blocking and reporting
- Profile verification system
- Safe messaging system

## Monetization Strategy

- **Premium Subscriptions**: Advanced features, unlimited groups, priority support
- **Local Business Partnerships**: Featured listings, sponsored events
- **Event Ticket Sales**: Commission on paid events and workshops

## Development Roadmap

- [ ] Complete Firebase integration
- [ ] Implement location services
- [ ] Add group creation and management
- [ ] Implement event system
- [ ] Add messaging functionality
- [ ] Implement safety features
- [ ] Add premium features
- [ ] Launch beta testing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@sisterhoodapp.com or create an issue in the repository.