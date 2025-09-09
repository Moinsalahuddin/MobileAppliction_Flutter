// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripbudget/screens/auth/login_screen.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Create a simple test widget without Firebase dependencies
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
      ),
    );
    
    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the login screen loads
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('TripBudget'), findsOneWidget);
    expect(find.text('Track your travel expenses'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
