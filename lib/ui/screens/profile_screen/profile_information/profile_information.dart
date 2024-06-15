import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/regex_validation.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:ionicons/ionicons.dart';

String female = 'Nữ';
String male = 'Nam';

enum Gender { male, female }

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});
  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  Gender? _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Thông tin cá nhân'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUserAvatar(context),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsLarge,
          ),
          // Name & ID
          _buildUserNameAndID(context),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsLarge,
          ),
          // User info customize
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    AppInput(
                      controller: nameController,
                      label: 'Tên',
                      hintText: 'Jathan Đỗ',
                    ),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsMedium,
                    ),
                    // Email
                    AppInput(
                      controller: emailController,
                      label: 'Email',
                      hintText: 'abc@gmail.com',
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsMedium,
                    ),
                    // Phone number
                    AppInput(
                      controller: phoneController,
                      label: 'Số điện thoại',
                      hintText: '0909 255 761',
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
                    // Birthday
                    AppInput(
                      suffixIcon: const Icon(Ionicons.calendar_outline),
                      controller: birthdateController,
                      label: 'Ngày sinh',
                      hintText: 'Ngày sinh',
                      validator: (value) {
                        if (value!.isEmpty || value.isEmpty) {
                          return 'Hãy chọn ngày!';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Format to accept valid date
                        await RegexValidation.formatDate(
                            context, birthdateController);
                      },
                    ),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsMedium,
                    ),
                    Text(
                      'Giới tính',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ColorConfig.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsMedium,
                    ),
                    // Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRadioGender(Gender.male, 'Nam'),
                        _buildRadioGender(Gender.female, 'Nữ'),
                      ],
                    ),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsLarge,
                    ),
                    // Update button
                    AppButton(text: 'Cập Nhật', onPressed: () {}),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded _buildRadioGender(Gender gender, String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: const BoxDecoration(
            color: ColorConfig.secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<Gender>(
              fillColor: MaterialStateProperty.all(ColorConfig.primaryColor),
              value: gender,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            Text(title)
          ],
        ),
      ),
    );
  }

  Stack _buildUserAvatar(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: CachedNetworkImage(
              width: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
              height: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
              fit: BoxFit.contain,
              imageUrl: //Replace later
                  'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436200.jpg?size=338&ext=jpg&ga=GA1.1.1141335507.1717891200&semt=ais_user',
              placeholder: (context, url) => const LoadingIndicator(),
            ),
          ),
        ),
        Positioned(
          right: ConstraintConfig.getWidth(context) / 2 - 50,
          bottom: 0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: ColorConfig.primaryColor,
                borderRadius: BorderRadius.circular(100)),
            child: IconButton(
                iconSize: 20,
                onPressed: () {},
                icon: const Icon(
                  Ionicons.camera_outline,
                  color: ColorConfig.accentColor,
                )),
          ),
        )
      ],
    );
  }

  Container _buildUserNameAndID(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      color: ColorConfig.secondaryColor,
      child: Column(
        children: [
          Text(
            'Jason Huỳnh',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: const <TextSpan>[
                TextSpan(
                  text: 'ID: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'US-1241415',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
