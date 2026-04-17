// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../constants/app_colors.dart';

// /// Defines the global Material theme.
// /// All screens inherit these styles automatically.
// class AppTheme {
//   AppTheme._();

//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       textTheme: GoogleFonts.plusJakartaSansTextTheme(),
//       colorScheme: const ColorScheme.light(
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//         surface: AppColors.surface,
//         error: AppColors.error,
//       ),

//       // Page background color
//       scaffoldBackgroundColor: AppColors.background,

//       // AppBar: white background, no elevation
//       appBarTheme: const AppBarTheme(
//         backgroundColor: AppColors.surface,
//         foregroundColor: AppColors.textPrimary,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         titleTextStyle: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//       ),

//       // Default ElevatedButton style (primary blue)
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 13),
//           textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//       ),

//       // Default TextFormField / TextField styles
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.background,
//         hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(
//             color: AppColors.borderLight,
//             width: 0.5,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(
//             color: AppColors.borderLight,
//             width: 0.5,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.error, width: 0.8),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.error, width: 1.2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 10,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background, // Warm Cream #FAF7F2
      // Setting Cormorant Garamond for display and Plus Jakarta for body
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary, // Deep Eucalyptus #2D4A3E
        secondary: AppColors.secondary, // Terracotta/Amber
        surface: AppColors.surface, // Warm Cream
        onPrimary: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // Premium rounded buttons with Eucalyptus fill
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Chip theme for the category selectors
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        secondaryLabelStyle: const TextStyle(fontSize: 13, color: Colors.white),
        shape: StadiumBorder(side: BorderSide(color: AppColors.borderLight)),
      ),
    );
  }
}
