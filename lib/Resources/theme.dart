import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildThemeData() {
  return ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      ),
      displayMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      displaySmall: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
      ),
      headlineLarge: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      headlineMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      headlineSmall: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      ),
      titleLarge: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      titleMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
      ),
      titleSmall: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      ),
      bodyLarge: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 16.0, color: Colors.black87),
      ),
      bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 14.0, color: Colors.black54),
      ),
      bodySmall: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 12.0, color: Colors.black45),
      ),
      labelLarge: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      labelMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
      ),
      labelSmall: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blueAccent,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
    ),
  );
}
