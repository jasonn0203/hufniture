// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/configs/validators.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class ConfirmResetPasswordScreen extends StatelessWidget {
  final String email;
  ConfirmResetPasswordScreen({super.key, required this.email});

  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đặt lại mật khẩu'),
      body: Padding(
        padding: ConstraintConfig.kHorizontalPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              Text(
                'Đổi mật khẩu',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: ColorConfig.mainTextColor, fontSize: 20),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsSmall,
              ),
              Text(
                'Nhập lại mật khẩu trùng khớp để tiến hành đổi',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: ColorConfig.mainTextColor),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 3,
              ),
              AppInput(
                controller: pwController,
                label: 'Mật khẩu',
                hintText: '●●●●●●●●',
                isObscure: true,
                validator: Validators.validatePassword,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              AppInput(
                controller: confirmPwController,
                label: 'Nhập lại mật khẩu',
                hintText: '●●●●●●●●',
                isObscure: true,
                validator: (value) =>
                    Validators.validatePasswordMatch(pwController.text, value),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  width: ConstraintConfig.getWidth(context),
                  text: 'Đổi mật khẩu',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Handle reset password
                      bool success = await _authService.resetPassword(
                        email,
                        pwController.text.trim(),
                        confirmPwController.text.trim(),
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Đặt lại mật khẩu thành công!')),
                        );
                        RouteConfig.navigateTo(context, LoginScreen(),
                            pushScreenType: PushScreenType.pushAndRemoveUntil);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đặt lại mật khẩu thất bại!')),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
