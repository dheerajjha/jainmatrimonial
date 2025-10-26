import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Jain Aesthetic Colors
  static const Color primary = Color(0xFFFF9933); // Saffron
  static const Color secondary = Color(0xFFD4AF37); // Gold
  static const Color background = Color(0xFFFFFBF5); // Warm white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimary = Color(0xFF2C2C2C); // Dark gray
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color accent = Color(0xFFFFE4B5); // Light gold
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
    ),

    // Scaffold
    scaffoldBackgroundColor: background,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: textPrimary),
      titleTextStyle: GoogleFonts.poppins(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: surface,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error),
      ),
      labelStyle: GoogleFonts.lato(
        color: textSecondary,
        fontSize: 14,
      ),
      hintStyle: GoogleFonts.lato(
        color: textSecondary.withOpacity(0.5),
        fontSize: 14,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: textSecondary.withOpacity(0.2),
      thickness: 1,
    ),
  );

  // Helper method for gradient background
  static BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        background,
        surface,
      ],
    ),
  );

  // Helper method for card shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: textSecondary.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
