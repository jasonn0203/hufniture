import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/forgot_password_screen/confirm_reset_password_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({super.key});

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  TextEditingController currentPwController = TextEditingController();

  TextEditingController newPwController = TextEditingController();
  TextEditingController confirmNewPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Cài Đật Mật Khẩu'),
      body: Padding(
        padding: ConstraintConfig.kHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 2,
            ),
            AppInput(
              controller: currentPwController,
              label: 'Mật khẩu hiện tại',
              hintText: '●●●●●●●●',
              isObscure: true,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      RouteConfig.navigateTo(
                          context, ConfirmResetPasswordScreen());
                    },
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(color: ColorConfig.primaryColor),
                    ))),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 2,
            ),
            AppInput(
              controller: newPwController,
              label: 'Mật khẩu mới',
              hintText: '●●●●●●●●',
              isObscure: true,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            AppInput(
              controller: confirmNewPwController,
              label: 'Nhập lại mật khẩu mới',
              hintText: '●●●●●●●●',
              isObscure: true,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
            ),
            Align(
              alignment: Alignment.center,
              child: AppButton(
                width: ConstraintConfig.getWidth(context),
                text: 'Đổi mật khẩu',
                onPressed: () {
                  // Handle reset password
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
