import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'City Guide';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (if using external APIs)
  static const String baseUrl = 'https://api.cityguide.com';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String citiesCollection = 'cities';
  static const String attractionsCollection = 'attractions';
  static const String reviewsCollection = 'reviews';
  
  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String selectedCityKey = 'selected_city';
  static const String isFirstLaunchKey = 'is_first_launch';
  
  // Default Values
  static const double defaultLatitude = 40.7128;
  static const double defaultLongitude = -74.0060;
  static const double defaultZoom = 12.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Sizes
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  
  // Text Sizes
  static const double textSizeSmall = 12.0;
  static const double textSizeMedium = 14.0;
  static const double textSizeLarge = 16.0;
  static const double textSizeXLarge = 18.0;
  static const double textSizeXXLarge = 24.0;
  
  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String generalError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String permissionError = 'Permission denied. Please grant the required permissions.';
  
  // Success Messages
  static const String profileUpdated = 'Profile updated successfully!';
  static const String reviewSubmitted = 'Review submitted successfully!';
  static const String attractionAdded = 'Attraction added successfully!';
  static const String passwordResetSent = 'Password reset email sent!';
}

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFE0B2);
  
  static const Color accent = Color(0xFF4CAF50);
  static const Color accentDark = Color(0xFF388E3C);
  static const Color accentLight = Color(0xFFC8E6C9);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  static const Color divider = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1976D2);
  
  static const Color rating = Color(0xFFFFD700);
  static const Color favorite = Color(0xFFE91E63);
  static const Color mapMarker = Color(0xFF2196F3);
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle headline4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
    fontFamily: 'Poppins',
  );
}

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration inputDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    border: Border.all(color: AppColors.divider),
  );
  
  static BoxDecoration buttonDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
  );
  
  static BoxDecoration outlinedButtonDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    border: Border.all(color: AppColors.primary),
  );
}
