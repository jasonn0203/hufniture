import 'package:flutter/material.dart';

import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/input/app_input.dart';

class PaymentAddressScreen extends StatelessWidget {
  const PaymentAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController addressController = TextEditingController();
    return Scaffold(
      appBar: const CustomAppbar(title: 'Sửa Địa Chỉ'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppInput(
              controller: addressController,
              label: 'Địa Chi',
              hintText: '123 Lê Duẩn, Quận 1',
              maxLines: 2,
              inputType: TextInputType.streetAddress,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            AppButton(text: 'Cập Nhật', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
