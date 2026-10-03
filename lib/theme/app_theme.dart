import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFE50914); // Wynk-like red
  static const Color backgroundColor = Color(0xFF121212); // Dark background
  static const Color surfaceColor = Color(0xFF1E1E1E); // Slightly lighter for cards
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Colors.white70;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: surfaceColor,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor),
        displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: Colors.white24,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withAlpha(51),
      ),
    );
  }
}
