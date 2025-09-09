import 'package:flutter/material.dart';

class TravelColors {
  // Background colors
  static const Color background = Color(0xFFF5F6F6);        // Light off-white/pale grey
  static const Color cardWhite = Color(0xFFFFFFFF);         // Pure white for cards
  
  // Text colors
  static const Color primaryText = Color(0xFF111111);       // Dark black for main text
  static const Color secondaryText = Color(0xFF222222);     // Dark grey for secondary text
  static const Color inactiveGrey = Color(0xFF9E9E9E);      // Light grey for inactive icons/text
  
  // Primary colors
  static const Color primaryOrange = Color(0xFFFF7A00);     // Main orange for buttons/highlights
  static const Color ratingOrange = Color(0xFFFFB800);      // Bright orange/yellow for ratings
  
  // Status colors
  static const Color successGreen = Color(0xFF4CAF50);      // Green for success states
  static const Color errorRed = Color(0xFFF44336);          // Red for error states
  static const Color warningAmber = Color(0xFFFF9800);      // Amber for warnings
  
  // Shadow colors
  static Color shadowColor = Colors.grey.withOpacity(0.1);
  static Color lightShadowColor = Colors.grey.withOpacity(0.05);
  
  // Gradient colors
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF7A00), Color(0xFFFF9500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
