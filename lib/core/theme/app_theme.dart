import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF004532);
  static const Color primaryContainer = Color(0xFF065F46);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF8BD6B7);
  static const Color primaryFixed = Color(0xFFA6F2D1);
  static const Color primaryFixedDim = Color(0xFF8BD6B6);

  static const Color secondaryColor = Color(0xFF006C49);
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00714D);
  static const Color secondaryFixed = Color(0xFF6FFBBE);
  static const Color secondaryFixedDim = Color(0xFF4EDEA3);
  static const Color onSecondaryFixed = Color(0xFF002113);

  static const Color tertiaryFixed = Color(0xFFFFDAD7);
  static const Color tertiaryFixedDim = Color(0xFFFFB3AD);

  static const Color inverseSurface = Color(0xFF293040);
  static const Color inverseOnSurface = Color(0xFFEDF0FF);
  static const Color inversePrimary = Color(0xFF8BD6B6);

  static const Color tertiaryColor = Color(0xFF7F000F);
  static const Color tertiaryContainer = Color(0xFFA9081A);
  static const Color onTertiaryColor = Color(0xFFFFFFFF);

  static const Color backgroundColor = Color(0xFFF9F9FF);
  static const Color surfaceColor = Color(0xFFF9F9FF);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceDim = Color(0xFFD3DAEF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F3FF);
  static const Color surfaceContainer = Color(0xFFE9EDFF);
  static const Color surfaceContainerHigh = Color(0xFFE1E8FD);
  static const Color surfaceContainerHighest = Color(0xFFDCE2F7);

  static const Color onSurfaceColor = Color(0xFF141B2B);
  static const Color onSurfaceVariant = Color(0xFF3F4944);
  static const Color outlineColor = Color(0xFF6F7973);
  static const Color outlineVariant = Color(0xFFBEC9C2);

  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiaryColor,
        onTertiary: onTertiaryColor,
        tertiaryContainer: tertiaryContainer,
        error: errorColor,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        onSurfaceVariant: onSurfaceVariant,
        outline: outlineColor,
        outlineVariant: outlineVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );
  }
}
