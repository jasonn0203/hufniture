import 'package:flutter/material.dart';

class ConstraintConfig {
  static double kSpaceBetweenItemsUltraLarge = 24.0;
  static double kSpaceBetweenItemsLarge = 20.0;
  static double kSpaceBetweenItemsMedium = 14.0;
  static double kSpaceBetweenItemsSmall = 7.0;

  static EdgeInsets kHorizontalPadding =
      EdgeInsets.symmetric(horizontal: kSpaceBetweenItemsUltraLarge);

  //Get screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //Get screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
