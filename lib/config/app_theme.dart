import 'package:flutter/material.dart';
import '../config/app_font.dart';

class AppTheme {
  static const Color dark = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF636373);
  static const Color lightBlack = Color(0xFF191919);
  static const Color settingIconsColors = Color(0xFF21364A);
  static const Color followButtonColor = Color(0xFF50D6EF);
  static const Color kPrimaryColor = Color(0xFFFF8038);
  static const Color kButtonColor = Color(0xFFFF8038);
  static const Color greenColor = Colors.green;
  static const Color unSelectedColor = Color(0xFF2CBCB1);
  static const Color greyColor = Color(0xFF909096);
  static const Color greyColor2 = Color(0xFF636373);
  static const Color error = Color(0xFFFF0010);
  static const Color lightBlacks = Color(0xFF000000);

  static const List<Color> primaryGradient = [
    Color(0xFF2CBCB1),
    Color(0xFF0A6860),
  ];

  static const Color textFieldGradient1 = Color(0xFFFFFFFF);
  static const Color textFieldGradient2 = Color(0xFFF319C3);
  static const Color textFieldGradient3 = Color(0xFFD58E1C);
  static const Color white = Colors.white;
  static const Color greyLight = Color(0xFFCCCCCC);
  static const Color halfBlack = Color(0xFF000000);
  static Color blueHover = const Color(0xFF0F5AD6);
  static Color bluePressed = const Color(0xFF0A47B8);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppTheme.dark,

    colorScheme: const ColorScheme.dark(
      onPrimary: AppTheme.white,
      secondary: AppTheme.kPrimaryColor,
      onSecondary: AppTheme.white,
      error: AppTheme.kPrimaryColor,
      onError: AppTheme.white,
      surface: AppTheme.grey,
      onSurface: AppTheme.white,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontFamily: AppFonts.lato,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppTheme.unSelectedColor,
        disabledForegroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        disabledForegroundColor: AppTheme.unSelectedColor,
        side: const BorderSide(color: AppTheme.kPrimaryColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.kPrimaryColor,
        disabledForegroundColor: AppTheme.unSelectedColor,
        textStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppTheme.grey.withValues(alpha: 0.2),
      selectedColor: AppTheme.kPrimaryColor,
      labelStyle: const TextStyle(
        fontFamily: AppFonts.lato,
        color: Colors.white,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: AppFonts.lato,
        color: Colors.white70,
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppTheme.kPrimaryColor,
      unselectedLabelColor: Colors.white70,
      labelStyle: TextStyle(
        fontFamily: AppFonts.lato,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontFamily: AppFonts.lato),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 2),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppTheme.greenColor,
      foregroundColor: Colors.white,
    ),
  );
}
