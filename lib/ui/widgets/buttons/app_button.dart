import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final double height;
  final double width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.height = 50,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: isPrimary
                ? MaterialStateProperty.all(ColorConfig.primaryColor)
                : MaterialStateProperty.all(ColorConfig.secondaryColor)),
        child: FittedBox(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                color: isPrimary
                    ? ColorConfig.secondaryColor
                    : ColorConfig.accentColor),
          ),
        ),
      ),
    );
  }
}
