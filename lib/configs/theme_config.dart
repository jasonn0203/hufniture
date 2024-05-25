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
      fontFamily: 'LeagueSpartan',
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: ColorConfig.mainTextColor,
      fontFamily: 'LeagueSpartan',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: ColorConfig.primaryColor,
    textTheme: _titleTextTheme.merge(_bodyTextTheme),
  );
}
