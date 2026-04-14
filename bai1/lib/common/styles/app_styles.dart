
import 'package:flutter/material.dart';

class AppStyles {
  static const Color primary    = Color(0xFF3F51B5);
  static const Color accent     = Color(0xFF5C6BC0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBg     = Colors.white;
  static const Color textPrimary   = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error      = Color(0xFFE53935);

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13, color: textSecondary,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11, color: textSecondary,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static const double paddingS  = 8.0;
  static const double paddingM  = 16.0;
  static const double paddingL  = 24.0;
  static const double radiusM   = 10.0;
}