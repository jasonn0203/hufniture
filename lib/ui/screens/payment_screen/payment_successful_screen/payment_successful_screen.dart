import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';

import 'package:hufniture/ui/screens/app_navigation/app_navigation.dart';
import 'package:hufniture/ui/screens/order_screen/order_list_screen/order_list_screen.dart';

import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt Hàng Thành Công'),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ColorConfig.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('${Helpers.imgUrl}/pay_successful.png'),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
            const AppCustomText(content: 'Cảm Ơn Bạn', isTitle: true),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: <TextSpan>[
                  const TextSpan(text: 'Đơn Hàng Đã Đặt '),
                  const TextSpan(
                    text: 'Thành Công',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConfig.primaryColor,
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
                    onPressed: () {
                      RouteConfig.navigateTo(
                        context,
                        const AppNavigation(index: 0),
                        pushScreenType: PushScreenType.pushAndRemoveUntil,
                      );
                    },
                    isPrimary: false,
                  ),
                ),
                SizedBox(width: ConstraintConfig.kSpaceBetweenItemsLarge),
                Expanded(
                  child: AppButton(
                    text: 'Theo Dõi',
                    onPressed: () {
                      RouteConfig.navigateTo(context, const OrderListScreen());
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
