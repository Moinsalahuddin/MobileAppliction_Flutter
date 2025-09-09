import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headline Styles
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
  
  // Body Styles
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
  
  static const TextStyle body3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );
  
  // Caption Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );
  
  // Button Styles
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle buttonOutlined = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontFamily: 'Poppins',
  );
  
  // Special Styles
  static const TextStyle rating = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.rating,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle category = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.surface,
    fontFamily: 'Poppins',
  );
}

class AppDecorations {
  // Card Decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  // Input Decorations
  static BoxDecoration inputDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.divider),
  );
  
  static BoxDecoration inputDecorationFocused = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.primary, width: 2),
  );
  
  // Button Decorations
  static BoxDecoration buttonDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(8),
  );
  
  static BoxDecoration buttonDecorationOutlined = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.primary),
  );
  
  static BoxDecoration buttonDecorationSecondary = BoxDecoration(
    color: AppColors.secondary,
    borderRadius: BorderRadius.circular(8),
  );
  
  // Category Badge Decorations
  static BoxDecoration categoryBadgeDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(16),
  );
  
  static BoxDecoration categoryBadgeDecorationSecondary = BoxDecoration(
    color: AppColors.secondary,
    borderRadius: BorderRadius.circular(16),
  );
  
  // Rating Badge Decorations
  static BoxDecoration ratingBadgeDecoration = BoxDecoration(
    color: AppColors.rating,
    borderRadius: BorderRadius.circular(12),
  );
  
  // Map Marker Decorations
  static BoxDecoration mapMarkerDecoration = BoxDecoration(
    color: AppColors.mapMarker,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppColors.mapMarker.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient overlayGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black54],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
