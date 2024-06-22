import 'package:flutter/material.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class PaymentFailScreen extends StatelessWidget {
  const PaymentFailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đật Hàng Thất Bại'),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.red),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('${Helpers.imgUrl}/pay_fail.png'),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsLarge,
            ),
            AppCustomText(
              content: 'Ooops, Xin lỗi',
              isTitle: true,
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.red),
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsLarge,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Đơn Hàng Đã Đặt ',
                  ),
                  TextSpan(
                    text: 'Thất Bại',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                  text: 'Quay Về',
                  onPressed: () {},
                  isPrimary: false,
                )),
                SizedBox(
                  width: ConstraintConfig.kSpaceBetweenItemsLarge,
                ),
                Expanded(child: AppButton(text: 'Lý Do', onPressed: () {}))
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
