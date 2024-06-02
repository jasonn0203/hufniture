import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';

class CustomTheme {
  static const TextTheme _titleTextTheme = TextTheme(
    titleLarge: TextStyle(
      color: ColorConfig.primaryColor,
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: ColorConfig.primaryColor,
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: ColorConfig.primaryColor,
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );

  static const TextTheme _bodyTextTheme = TextTheme(
    bodySmall: TextStyle(
      color: ColorConfig.descTextColor,
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: ColorConfig.mainTextColor,
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      color: ColorConfig.mainTextColor,
      fontFamily: 'Roboto',
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    primaryColor: ColorConfig.primaryColor,
    textTheme: _titleTextTheme.merge(_bodyTextTheme),
  );
}
