import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/secure_database.dart';
import 'services/biometric_auth.dart';
import 'services/app_lock.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure local database
  await SecureDatabase.initialize();
  
  // Check biometric availability
  await BiometricAuth.isAvailable();
  
  runApp(const SisterhoodApp());
}

class SisterhoodApp extends StatelessWidget {
  const SisterhoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Sisterhood',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: const Color(0xFFE91E63),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE91E63),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
            ),
          ),
        ),
        home: const AppWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const SplashScreen();
        }
        
        if (authProvider.user == null) {
          return const LoginScreen();
        }
        
        return const HomeScreen();
      },
    );
  }
}