// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await SharedPreferencesHelper.getUser();
        final userId = user?['id'];

        if (userId != null) {
          final result = await AuthService().changePassword(
            userId,
            currentPassword: currentPwController.text,
            newPassword: newPwController.text,
            confirmNewPassword: confirmNewPwController.text,
          );

          if (result) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Đổi mật khẩu thành công'),
                  backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không tìm thấy người dùng'),
                backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        final errorMessage = e.toString();
        print('Error: $errorMessage'); // Logging error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Cài Đặt Mật Khẩu'),
      body: Padding(
        padding: ConstraintConfig.kHorizontalPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 2),
              AppInput(
                controller: currentPwController,
                label: 'Mật khẩu hiện tại',
                hintText: '●●●●●●●●',
                isObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () async {
                        final user = await SharedPreferencesHelper.getUser();
                        final userEmail = user?['email'];
                        RouteConfig.navigateTo(
                            context,
                            ConfirmResetPasswordScreen(
                              email: userEmail,
                            ));
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(color: ColorConfig.primaryColor),
                      ))),
              SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 2),
              AppInput(
                controller: newPwController,
                label: 'Mật khẩu mới',
                hintText: '●●●●●●●●',
                isObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  return null;
                },
              ),
              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
              AppInput(
                controller: confirmNewPwController,
                label: 'Nhập lại mật khẩu mới',
                hintText: '●●●●●●●●',
                isObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu mới';
                  }
                  return null;
                },
              ),
              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsUltraLarge),
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  width: ConstraintConfig.getWidth(context),
                  text: 'Đổi mật khẩu',
                  onPressed: _changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
