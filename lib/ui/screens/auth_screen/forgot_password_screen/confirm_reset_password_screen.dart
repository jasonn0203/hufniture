import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/auth_selection_screen/auth_selection_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class ConfirmResetPasswordScreen extends StatelessWidget {
  ConfirmResetPasswordScreen({super.key});
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đặt lại mật khẩu'),
      body: Padding(
        padding: ConstraintConfig.kHorizontalPadding,
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
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            AppInput(
              controller: confirmPwController,
              label: 'Nhập lại mật khẩu',
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

                  RouteConfig.navigateTo(context, const AuthSelectionScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
