import 'package:flutter/material.dart';

// Colors

class AppColors {
  static const Color primary = Color(0xFF004182);
  static const Color primaryLight = Color(0xFF4A7FFF);
  static const Color secondary = Color(0xFFFFD700);

  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF0D1B3E);

  static const Color card = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2D5A);
  static const Color inputBg = Color(0xFFF8F9FF);

  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A2D5A);
  static const Color label = Color(0xFFC8D8FF);
  static const Color placeholder = Color(0xFF8A9CC4);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);

  static const Color error = Color(0xFFFF6B8A);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFF6D00);

  static const Color starColor = Color(0xFFFFB300);
  static const Color priceColor = Color(0xFF004182);
  static const Color discountColor = Color(0xFFE53935);
}

// Text Styles
class AppTextStyles {
  // From Dark Auth Theme
  static const TextStyle heading = TextStyle(
    color: AppColors.white,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextStyle subheading = TextStyle(
    color: AppColors.label,
    fontSize: 13,
    height: 1.6,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.label,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonText = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  static const TextStyle linkText = TextStyle(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  static const TextStyle mutedText = TextStyle(
    color: AppColors.label,
    fontSize: 13,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle body = TextStyle(fontSize: 14, color: AppColors.black);

  static const TextStyle bodyGrey = TextStyle(
    fontSize: 13,
    color: AppColors.grey,
  );

  static const TextStyle price = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.priceColor,
  );

  static const TextStyle priceOld = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle smallGrey = TextStyle(
    fontSize: 11,
    color: AppColors.grey,
  );

  static const TextStyle buttonTextLight = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}

// Theme
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.backgroundDark,
      ),
    );
  }
}
