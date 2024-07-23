// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  final List<String> _genders = ['Nam', 'Nữ'];
  final AuthService _userService = AuthService();
  late String userId = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await SharedPreferencesHelper
          .getUser(); // Giả sử bạn có phương thức này để lấy user
      if (user == null) {
        // Nếu không có user, không thể lấy dữ liệu người dùng
        return;
      }

      final userInfo = await _userService.getUserInfo(user['id']);
      if (userInfo != null) {
        setState(() {
          _fullNameController.text = userInfo['fullName'] ?? '';
          _phoneNumberController.text = userInfo['phoneNumber'] ?? '';
          _birthDate = userInfo['birthDate'] != null
              ? DateTime.parse(userInfo['birthDate'])
              : null;
          _gender = _genders.contains(userInfo['gender'])
              ? userInfo['gender']
              : _genders[0]; // Đặt giá trị mặc định nếu không hợp lệ
          userId = user['id'];
        });
      }
    } catch (e) {
      print('Failed to load user data: $e');
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await SharedPreferencesHelper.getUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy thông tin người dùng!')),
        );
        return;
      }

      try {
        final success = await _userService.updateUser(
          user,
          userId: user['id'] ?? '',
          fullName: _fullNameController.text,
          phoneNumber: _phoneNumberController.text,
          birthDate: _birthDate,
          gender: _gender,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Cập nhật thông tin thành công!'
                : 'Cập nhật thất bại!'),
          ),
        );
      } catch (e) {
        print('Failed to update user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thất bại!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Thông tin cá nhân'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Avatar
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CachedNetworkImage(
                      width: ConstraintConfig.responsive(
                          context, 150.0, 130.0, 120.0),
                      height: ConstraintConfig.responsive(
                          context, 150.0, 130.0, 120.0),
                      fit: BoxFit.contain,
                      imageUrl: 'https://loremflickr.com/320/240/user,face',
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
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {},
                      icon: const Icon(Ionicons.camera_outline,
                          color: ColorConfig.accentColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
            // ID
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: ColorConfig.secondaryColor,
              ),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'ID: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: userId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),

            //Form
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppInput(
                      label: 'Tên',
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                    AppInput(
                      label: 'Số điện thoại',
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập SĐT';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                    Text(
                      'Ngày sinh',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ColorConfig.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    ListTile(
                      subtitle: Text(_birthDate != null
                          ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                          : 'Chọn ngày sinh'),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _birthDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          final currentDate = DateTime.now();
                          final age = currentDate.year -
                              selectedDate.year -
                              ((currentDate.month < selectedDate.month ||
                                      (currentDate.month ==
                                              selectedDate.month &&
                                          currentDate.day < selectedDate.day))
                                  ? 1
                                  : 0);

                          if (age >= 18) {
                            setState(() {
                              _birthDate = selectedDate;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Bạn phải đủ 18 tuổi để đăng ký.')),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      items: _genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Giới tính'),
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || !_genders.contains(value)) {
                          return 'Vui lòng chọn giới tính';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AppButton(text: 'Cập Nhật', onPressed: _updateUser),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
