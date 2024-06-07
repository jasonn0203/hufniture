import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        size: 50,
        color: ColorConfig.primaryColor,
      ),
    );
  }
}
