import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/forgot_password_screen/confirm_reset_password_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Quên mật khẩu'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ConstraintConfig.kHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
                ),
                Text(
                  'Reset Mật Khẩu?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorConfig.mainTextColor, fontSize: 20),
                ),
                SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsSmall,
                ),
                Text(
                  'Nhập Email đã đăng ký tài khoản của bạn để tiến hành cấp lại mật khẩu',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: ColorConfig.mainTextColor),
                ),
              ],
            ),
          ),

          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 3,
          ),

          // Email form
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: ConstraintConfig.kSpaceBetweenItemsUltraLarge),
              height: ConstraintConfig.getWidth(context),
              decoration: const BoxDecoration(
                  color: ColorConfig.secondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                children: [
                  AppInput(
                    controller: emailController,
                    label: 'Nhập Email bạn đã đăng ký',
                    hintText: 'abc@gmail.com',
                    inputType: TextInputType.emailAddress,
                    fillColor: Colors.white,
                  ),
                  SizedBox(
                    height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AppButton(
                      width: ConstraintConfig.getWidth(context) / 2,
                      text: 'Tiếp Theo',
                      onPressed: () {
                        // Handle check if email is signed up

                        RouteConfig.navigateTo(
                            context, ConfirmResetPasswordScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
