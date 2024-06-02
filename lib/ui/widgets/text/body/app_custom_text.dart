import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';

class AppCustomText extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final bool isTitle;
  final bool color; // Parameter if you want the color is Primary

  const AppCustomText({
    Key? key,
    required this.content,
    this.textStyle,
    this.isTitle = false,
    this.color = false, // Black color is default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For body text
    final defaultBodyStyle = Theme.of(context).textTheme.bodyMedium;
    // For title text
    final defaultTitleStyle = Theme.of(context).textTheme.titleMedium;

    // Condition if no color applied
    final style = isTitle ? defaultTitleStyle : defaultBodyStyle;

    // Combine condition if color is applied
    final combineStyle =
        color ? style?.copyWith(color: ColorConfig.primaryColor) : style;

    return Text(
      content,
      // if textStyle is null then apply combineStyle
      style: textStyle ?? combineStyle,
    );
  }
}
