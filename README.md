# Sisterhood - Local Women's Community App

A Flutter app that connects women in local communities for friendship, support, and shared activities with **advanced security** and **local storage**.

## 🔒 Advanced Security Features

- **AES Encryption** - Military-grade encryption for all local data
- **Biometric Authentication** - Fingerprint/Face ID protection
- **App Lock System** - PIN protection with timeout
- **Secure Key Storage** - OS-level keychain/keystore
- **Data Integrity** - Prevents tampering and corruption

## 💾 Local Storage System

- **Hive Database** - Fast, encrypted NoSQL database
- **100% Offline** - Works without internet
- **Automatic Encryption** - All data encrypted at rest
- **Secure Backup** - Encrypted data export/import
- **Data Privacy** - No data leaves your device

## 🌐 Railway Sync Server

- **100% FREE** - No credit card required
- **Worldwide Access** - Users globally
- **Auto-deployment** - Push code = live
- **Secure API** - Rate limiting, CORS, Helmet security
- **Real-time Sync** - Groups, events, messaging

## Features

- **User Authentication**: Secure sign-up and sign-in with local storage
- **Profile Management**: Create and manage user profiles with interests and location
- **Local Discovery**: Find women nearby with similar interests
- **Groups**: Join and create interest-based groups
- **Events**: Discover and attend local events
- **Safety Features**: Block and report users, verified profiles
- **Biometric Security**: Fingerprint/Face ID protection
- **App Lock**: PIN protection with timeout

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Local Database**: Hive with AES encryption
- **Sync Server**: Railway (Node.js + Express)
- **State Management**: Provider
- **Security**: Biometric authentication, app lock
- **Location**: Geolocator
- **Storage**: Encrypted local storage

## 🚀 Quick Start

### 1. Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- GitHub account (for Railway deployment)

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Hive Adapters

```bash
flutter packages pub run build_runner build
```

### 4. Deploy Railway Server

1. Go to [Railway.app](https://railway.app)
2. Connect your GitHub account
3. Deploy the `server` folder
4. Get your Railway URL
5. Update `lib/services/railway_sync.dart` with your URL

### 5. Run the App

```bash
flutter run
```

## 🔧 Project Structure

```
lib/
├── models/           # Data models with Hive adapters
├── screens/          # UI screens
│   ├── auth/        # Authentication screens
│   └── home/        # Main app screens
├── providers/        # State management
├── services/         # Business logic services
│   ├── secure_database.dart    # Encrypted local database
│   ├── biometric_auth.dart     # Biometric authentication
│   ├── app_lock.dart           # PIN protection
│   └── railway_sync.dart       # Server synchronization
└── utils/           # Utility functions

server/
├── server.js        # Railway server
├── package.json     # Server dependencies
└── README.md        # Deployment guide
```

## 🔒 Security Implementation

### Local Database Security
- **AES Encryption** - All data encrypted at rest
- **Secure Key Management** - Keys stored in OS keychain
- **Data Integrity** - Prevents tampering

### Authentication Security
- **Biometric Protection** - Fingerprint/Face ID
- **App Lock** - PIN protection with timeout
- **Secure Storage** - Encrypted preferences

### Server Security
- **Rate Limiting** - 100 requests per 15 minutes
- **CORS Protection** - Configurable origins
- **Helmet Security** - Security headers
- **Input Validation** - Required field checking

## 🌐 Railway Deployment

### Free Tier Benefits
- ✅ **500 hours/month** - More than enough for small apps
- ✅ **No credit card** required
- ✅ **Auto-deployment** from GitHub
- ✅ **SSL certificates** - HTTPS enabled
- ✅ **Global CDN** - Worldwide access

### Deployment Steps
1. **Fork this repository**
2. **Go to [Railway.app](https://railway.app)**
3. **Connect GitHub account**
4. **Deploy server folder**
5. **Get your Railway URL**
6. **Update app with Railway URL**

## 💰 Cost Breakdown

- **Flutter App**: FREE
- **Railway Server**: FREE (500 hours/month)
- **Local Storage**: FREE
- **Security Features**: FREE
- **Total Cost**: $0/month

## 🎯 Key Benefits

### Security
- ✅ **More secure than Firebase** - data never leaves device
- ✅ **Biometric protection** - fingerprint/face ID
- ✅ **Military-grade encryption** - AES encryption
- ✅ **Complete privacy** - no third-party access

### Performance
- ✅ **Faster than Firebase** - local database
- ✅ **Works offline** - no internet required
- ✅ **Lower latency** - instant local access
- ✅ **Better battery life** - no constant sync

### Control
- ✅ **Your own server** - Railway deployment
- ✅ **Your own data** - local storage
- ✅ **Your own code** - open source
- ✅ **Your own rules** - complete control

## Development Roadmap

- [x] Implement secure local database with Hive
- [x] Add biometric authentication
- [x] Create app lock system
- [x] Build Railway sync server
- [x] Remove Firebase dependencies
- [x] Add advanced security features
- [ ] Deploy Railway server
- [ ] Test all features
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

For support, create an issue in the repository or contact the development team.

---

**Built with ❤️ for women's communities worldwide**