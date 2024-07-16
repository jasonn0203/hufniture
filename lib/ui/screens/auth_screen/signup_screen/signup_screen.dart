import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/validators.dart';
import 'package:hufniture/data/models/Auth/user_register.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Tạo tài khoản'),
      body: SingleChildScrollView(
        child: Padding(
          padding: ConstraintConfig.kHorizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildSignupForm(),

              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              // Login button
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  width: ConstraintConfig.getWidth(context) / 2,
                  text: 'Đăng ký',
                  onPressed: () async {
                    // Check valid form value
                    if (_formKey.currentState!.validate()) {
                      // Handle signup
                      // Tạo đối tượng UserRegister từ các giá trị nhập vào
                      final user = UserRegister(
                        name: nameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        password: pwController.text,
                        confirmPassword: confirmPwController.text,
                      );

                      // Gọi API để đăng ký
                      final result = await _authService.registerUser(user);
                      //DK thành công
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                              content: Text('Đăng ký thành công!')),
                        );
                      }
                      //DK thất bại
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 4),
                              content: Text(result)),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              Text(
                'Hoặc đăng ký với',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(4.0),
                  icon: Image.asset('${Helpers.imgUrl}/logo_google.png'))
            ],
          ),
        ),
      ),
    );
  }

  Form buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppInput(
            controller: nameController,
            label: 'Tên',
            hintText: 'Jason Huynh',
            validator: Validators.validateNull,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsMedium,
          ),
          AppInput(
            controller: emailController,
            label: 'Email',
            hintText: 'abc@gmail.com',
            inputType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsMedium,
          ),
          AppInput(
            controller: phoneController,
            label: 'Số điện thoại',
            hintText: '0909 255 761',
            validator: Validators.validatePhoneNumber,
            inputType: TextInputType.phone,
            formatter: [
              // only allow from [0-9]
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              // digits only accept
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsMedium,
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
        ],
      ),
    );
  }
}
