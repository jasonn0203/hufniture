import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:page_transition/page_transition.dart';

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
              Text('Tiến hành đăng ký / đăng nhập để khám phá ngay Hufniture!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.normal)),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsLarge,
              ),
              AppButton(
                isPrimary: true,
                text: 'Đăng nhập',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const LoginScreen(),
                    ),
                  );
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
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
