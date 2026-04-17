// import 'package:flutter/material.dart';

// /// Central color palette — all colors in the app come from here.
// /// Change a value here and it updates everywhere automatically.
// class AppColors {
//   // Private constructor — this class should never be instantiated
//   AppColors._();

//   // ─── Brand ────────────────────────────────────────────────────
//   static const Color primary = Color(0xFF2563EB);    // Blue
//   static const Color secondary = Color(0xFFF59E0B);  // Amber

//   // ─── Backgrounds ──────────────────────────────────────────────
//   static const Color background = Color(0xFFF9FAFB); // Light gray page bg
//   static const Color surface = Color(0xFFFFFFFF);    // White card bg

//   // ─── Text ─────────────────────────────────────────────────────
//   static const Color textPrimary = Color(0xFF111827);   // Near-black
//   static const Color textSecondary = Color(0xFF6B7280); // Medium gray
//   static const Color textMuted = Color(0xFF9CA3AF);     // Light gray

//   // ─── Borders ──────────────────────────────────────────────────
//   static const Color border = Color(0xFFE5E7EB);
//   static const Color borderLight = Color(0xFFD1D5DB);

//   // ─── Semantic ─────────────────────────────────────────────────
//   static const Color success = Color(0xFF059669);
//   static const Color successLight = Color(0xFFD1FAE5);
//   static const Color warning = Color(0xFFD97706);
//   static const Color warningLight = Color(0xFFFEF3C7);
//   static const Color error = Color(0xFFEF4444);

//   // ─── Room Type Accents ────────────────────────────────────────
//   // Each room type has a matching accent + soft background pair
//   static const Color suiteAccent = Color(0xFF059669);
//   static const Color suiteBg = Color(0xFFD1FAE5);

//   static const Color deluxeAccent = Color(0xFF2563EB);
//   static const Color deluxeBg = Color(0xFFDBEAFE);

//   static const Color standardAccent = Color(0xFFD97706);
//   static const Color standardBg = Color(0xFFFEF3C7);

//   static const Color executiveAccent = Color(0xFFDB2777);
//   static const Color executiveBg = Color(0xFFFCE7F3);
// }

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand: Australian Boutique Palette ────────────────────────
  static const Color primary = Color(0xFF2D4A3E); // Eucalyptus Green
  static const Color secondary = Color(0xFFC67C4E); // Terracotta Amber
  static const Color accent = Color(0xFFA6633C); // Deep Earth

  // ─── Backgrounds ──────────────────────────────────────────────
  static const Color background = Color(0xFFFAF7F2); // Warm Cream
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceDark = Color(0xFFF3EFE9); // Soft Sand

  // ─── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1D1D1D); // Soft Black
  static const Color textSecondary = Color(0xFF5A5A5A); // Charcoal
  static const Color textMuted = Color(0xFF8E8E8E); // Stone Gray

  // ─── Borders ──────────────────────────────────────────────────
  static const Color border = Color(0xFFE8E2D9);
  static const Color borderLight = Color(0xFFF1EDE7);

  // ─── Semantic ─────────────────────────────────────────────────
  static const Color success = Color(0xFF486B5A);
  static const Color error = Color(0xFFB33A3A);

  // ─── UI Accents ───────────────────────────────────────────────
  static const Color ratingGold = Color(0xFFD4AF37);
  static const Color cardShadow = Color(0x0A000000);
}
