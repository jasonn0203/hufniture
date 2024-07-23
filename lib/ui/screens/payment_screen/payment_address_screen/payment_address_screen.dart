// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class PaymentAddressScreen extends StatelessWidget {
  const PaymentAddressScreen({
    super.key,
    required this.onUpdateAddress,
    required this.initialAddress, // Added parameter for initial address
  });

  final Future<void> Function() onUpdateAddress;
  final String? initialAddress; // New field to hold the initial address

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController =
        TextEditingController(text: initialAddress); // Set initial value
    final AuthService authService = AuthService();

    void _updateAddress() async {
      final user = await SharedPreferencesHelper.getUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Không tìm thấy thông tin người dùng.'),
          ),
        );
        return;
      }

      final userId = user['id'];
      final address = addressController.text;

      final error = await authService.updateUserAddress(userId, address);
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Cập nhật địa chỉ thành công!'),
          ),
        );

        await onUpdateAddress();
        Navigator.pop(context); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(error),
          ),
        );
      }
    }

    return Scaffold(
      appBar: const CustomAppbar(title: 'Sửa Địa Chỉ'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppInput(
              controller: addressController,
              label: 'Địa Chỉ',
              hintText: '123 Lê Duẩn, Quận 1',
              maxLines: 2,
              inputType: TextInputType.streetAddress,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            AppButton(text: 'Cập Nhật', onPressed: _updateAddress),
          ],
        ),
      ),
    );
  }
}
