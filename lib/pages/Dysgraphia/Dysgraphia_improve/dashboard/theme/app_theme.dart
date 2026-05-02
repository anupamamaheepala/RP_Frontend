// theme/app_theme.dart
// Central theme constants for the Dysgraphia Dashboard

import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────
  static const Color primary       = Color(0xFF6C3EE8); // deep purple
  static const Color primaryLight  = Color(0xFFEDE7FF);
  static const Color accent        = Color(0xFFFF7043); // warm orange
  static const Color accentLight   = Color(0xFFFFECE8);

  // Risk Level Colors
  static const Color riskLow       = Color(0xFF00C897); // green
  static const Color riskMedium    = Color(0xFFFFB300); // amber
  static const Color riskHigh      = Color(0xFFFF4C61); // red

  // Neutral
  static const Color background    = Color(0xFFF8F7FF);
  static const Color cardBg        = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1A1140);
  static const Color textSecondary = Color(0xFF7B7A8E);
  static const Color border        = Color(0xFFEAE8F5);

  // ── Text Styles ───────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    letterSpacing: 0.5,
  );

  // ── Card Decoration ───────────────────────────────────────────
  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
    color: color ?? cardBg,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: primary.withOpacity(0.07),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // ── Risk Level Helpers ────────────────────────────────────────
  static Color riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':    return riskLow;
      case 'medium': return riskMedium;
      case 'high':   return riskHigh;
      default:       return riskMedium;
    }
  }

  static String riskLabel(String level) {
    switch (level.toLowerCase()) {
      case 'low':    return 'අඩු අවදානම';
      case 'medium': return 'මධ්‍යම අවදානම';
      case 'high':   return 'ඉහළ අවදානම';
      default:       return level;
    }
  }

  static IconData riskIcon(String level) {
    switch (level.toLowerCase()) {
      case 'low':    return Icons.check_circle_rounded;
      case 'medium': return Icons.warning_rounded;
      case 'high':   return Icons.error_rounded;
      default:       return Icons.help_rounded;
    }
  }
}