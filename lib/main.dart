import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/theme_config.dart';

import 'package:hufniture/ui/screens/app_navigation/app_navigation.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  Future<bool> checkUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    return userString != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Helpers.appName,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: CustomTheme.lightTheme,
      home: const AppNavigation(index: 0),
    );
  }
}
