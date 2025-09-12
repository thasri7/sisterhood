// This is a basic Flutter widget test for Sisterhood app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisterhood_app/screens/splash_screen.dart';
import 'package:sisterhood_app/screens/auth/login_screen.dart';
import 'package:sisterhood_app/screens/auth/signup_screen.dart';

void main() {
  testWidgets('Splash screen displays correctly', (WidgetTester tester) async {
    // Build splash screen and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // Verify that the splash screen loads with app name
    expect(find.text('Sisterhood'), findsOneWidget);
    expect(find.text('Connect, Support, Thrive Together'), findsOneWidget);
    
    // Verify loading indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Verify app icon is present
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Build login screen
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify login screen elements
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    
    // Verify form fields are present
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
    
    // Verify app icon is present
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Sign up screen displays correctly', (WidgetTester tester) async {
    // Build signup screen
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    // Verify signup screen elements
    expect(find.text('Join Sisterhood'), findsOneWidget);
    expect(find.text('Create Account'), findsAtLeastNWidgets(1));
    
    // Verify form fields are present (Name, Email, Age, Location, Bio, Password, Confirm Password)
    expect(find.byType(TextFormField), findsNWidgets(7));
    
    // Verify interests section
    expect(find.text('Interests'), findsOneWidget);
    
    // Verify interest chips are present
    expect(find.byType(FilterChip), findsWidgets);
  });

  testWidgets('Login form fields are present', (WidgetTester tester) async {
    // Build login screen
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify email field
    expect(find.byType(TextFormField).first, findsOneWidget);
    
    // Verify password field
    expect(find.byType(TextFormField).last, findsOneWidget);
    
    // Verify sign in button
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Sign up form fields are present', (WidgetTester tester) async {
    // Build signup screen
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    // Verify all form fields are present
    expect(find.byType(TextFormField), findsNWidgets(7));
    
    // Verify create account button
    expect(find.text('Create Account'), findsAtLeastNWidgets(1));
    
    // Verify interests section
    expect(find.text('Interests'), findsOneWidget);
  });
}
