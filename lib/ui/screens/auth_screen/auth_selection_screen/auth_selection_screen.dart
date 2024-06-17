import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/screens/auth_screen/signup_screen/signup_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '${Helpers.imgUrl}/logo_hufniture.png',
                color: ColorConfig.primaryColor,
                fit: BoxFit.contain,
                scale: 3,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsLarge,
              ),
              AppCustomText(
                content:
                    'Tiến hành đăng ký / đăng nhập để khám phá ngay Hufniture!',
                textStyle: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsLarge,
              ),
              AppButton(
                isPrimary: true,
                text: 'Đăng nhập',
                onPressed: () {
                  RouteConfig.navigateTo(context, LoginScreen());
                },
                height: 60,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsLarge,
              ),
              AppButton(
                height: 60,
                isPrimary: false,
                text: 'Đăng ký',
                onPressed: () {
                  RouteConfig.navigateTo(context, SignupScreen());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
