// ignore_for_file: unused_import

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/theme_config.dart';
import 'package:hufniture/ui/screens/auth_screen/auth_selection_screen/auth_selection_screen.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/screens/auth_screen/signup_screen/signup_screen.dart';
import 'package:hufniture/ui/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(
    // Device Preview Lib - for simulate multiple devices on web
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Helpers.appName,
      //Config for device preview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // Config for theme
      theme: CustomTheme.lightTheme,
      //Startup screen
      home: const SplashScreen(),
    );
  }
}
