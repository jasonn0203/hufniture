// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Login'),
      body: Padding(
        padding: ConstraintConfig.kHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng!',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorConfig.mainTextColor, fontSize: 20),
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsSmall,
            ),
            Text(
              'Nhập thông tin tài khoản để truy cập ứng dụng',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: ColorConfig.mainTextColor),
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 3,
            ),
            // Form đăng nhập
            buildLoginForm(context),
            // Forgot Pw
            Expanded(child: buildAuthAction(context)),
          ],
        ),
      ),
    );
  }

  Column buildAuthAction(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            // Handle forgot password
          },
          child: Text(
            'Quên mật khẩu ?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: ConstraintConfig.kSpaceBetweenItemsMedium,
        ),
        // Sign up action
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chưa có tài khoản ?',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: ColorConfig.mainTextColor),
            ),
            TextButton(
              style:
                  TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                // Handle route to sign up
              },
              child: Text(
                'Tạo ngay',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        )
      ],
    );
  }

  Form buildLoginForm(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field
          AppInput(
            controller: emailController,
            label: 'Email',
            hintText: 'abc@gmail.com',
            inputType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
          ),
          AppInput(
            controller: passwordController,
            label: 'Mật khẩu',
            hintText: '●●●●●●●●',
            isObscure: true,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 3,
          ),

          // Login button
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  width: ConstraintConfig.getWidth(context) / 2,
                  text: 'Đăng nhập',
                  onPressed: () {
                    // Handle login
                  },
                ),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
