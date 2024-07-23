// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/configs/validators.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/ui/screens/app_navigation/app_navigation.dart';
import 'package:hufniture/ui/screens/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:hufniture/ui/screens/auth_screen/signup_screen/signup_screen.dart';
import 'package:hufniture/ui/screens/auth_screen/youtube_tutorial_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Login',
      ),
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
          child: InkWell(
            onTap: () {
              // Handle route to forgor pw screen
              RouteConfig.navigateTo(context, ForgotPasswordScreen());
            },
            child: Text(
              'Quên mật khẩu ?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
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
                RouteConfig.navigateTo(context, SignupScreen());
              },
              child: Text(
                'Tạo ngay',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        // Youtube link
        TextButton(
          style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            // Handle route to youtube link
            RouteConfig.navigateTo(context, const YoutubePlayerScreen());
          },
          child: Text(
            'Xem hướng dẫn',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }

  Form buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field
          AppInput(
            controller: emailController,
            label: 'Email',
            hintText: 'abc@gmail.com',
            inputType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
          ),
          AppInput(
            controller: passwordController,
            label: 'Mật khẩu',
            hintText: '●●●●●●●●',
            isObscure: true,
            validator: Validators.validatePassword,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsUltraLarge * 3,
          ),

          // Login button
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : AppButton(
                        width: ConstraintConfig.getWidth(context) / 2,
                        text: 'Đăng nhập',
                        onPressed: () async {
                          // Handle login
                          // Kiểm tra giá trị của form
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Gọi API đăng nhập
                            final errorMessage = await _authService.loginUser(
                                emailController.text, passwordController.text);

                            setState(() {
                              _isLoading = false;
                            });

                            if (errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                    content: Text('Đăng nhập thành công!')),
                              );
                              Navigator.pop(context);

                              // Xử lý chuyển hướng sau khi đăng nhập thành công
                              RouteConfig.navigateTo(
                                context,
                                const AppNavigation(index: 0),
                                pushScreenType:
                                    PushScreenType.pushAndRemoveUntil,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                    content: Text(errorMessage)),
                              );
                            }
                          }
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
