import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/ui/screens/onboarding_screen/onboarding_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          splash: Image.asset(
            '${Helpers.imgUrl}/logo_hufniture.png',
            fit: BoxFit.contain,
          ),
          nextScreen: const OnboardingScreen(),
          duration: 2000,
          pageTransitionType: PageTransitionType.rightToLeftWithFade,
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: ColorConfig.primaryColor,
          curve: Curves.easeInExpo,
        ),
      ),
    );
  }
}
