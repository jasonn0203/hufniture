import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/payment_screen/payment_address_screen/payment_address_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.totalPrice});
  final double totalPrice;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedValue = 'COD';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Thanh Toán'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCustomText(
                    content: 'Địa Chỉ Giao Hàng',
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      RouteConfig.navigateTo(
                          context, const PaymentAddressScreen());
                    },
                    child: const Icon(
                      Ionicons.create_outline,
                      color: ColorConfig.primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                width: ConstraintConfig.getWidth(context),
                height: ConstraintConfig.getHeight(context) * 0.116,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: ColorConfig.secondaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Ionicons.location_outline),
                        SizedBox(
                          width: ConstraintConfig.kSpaceBetweenItemsMedium,
                        ),
                        const AppCustomText(
                            content: '828 Sư Vạn Hạnh, Quận 10'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Ionicons.call_outline),
                        SizedBox(
                          width: ConstraintConfig.kSpaceBetweenItemsMedium,
                        ),
                        const AppCustomText(content: '858 2881 470'),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsLarge,
              ),
              // Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCustomText(
                    content: 'Đơn Hàng',
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Ionicons.create_outline,
                      color: ColorConfig.primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              Column(
                children: [
                  _buildOrderItem('Ghế Sofa', 1),
                  _buildOrderItem('Ghế dựa', 2),
                  _buildOrderItem('Kệ tủ', 4),
                ],
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              // Total Price
              _buidTotalPrice(context),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              // Payment Methods
              _buildPaymentMethods(context),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              // Estimate Shipping time
              AppCustomText(
                content: 'Thời Giao Giao Hàng',
                textStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppCustomText(
                    content: 'Dự Kiến',
                    textStyle: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  AppCustomText(
                    content: '2 Ngày',
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              AppButton(text: 'Thanh Toán Ngay', onPressed: () {}),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildPaymentMethods(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: AppCustomText(
            content: 'Phương Thức Thanh Toán',
            textStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            elevation: 1,
            icon: const Icon(Ionicons.chevron_down),
            iconSize: 16,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }

  Row _buidTotalPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppCustomText(
          content: 'Tổng cộng',
          textStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppCustomText(
          content: Helpers.formatPrice(widget.totalPrice),
          isTitle: true,
        )
      ],
    );
  }

  Widget _buildOrderItem(String name, int quantity) {
    return Row(
      children: [
        Expanded(child: AppCustomText(content: name)),
        Expanded(child: AppCustomText(content: 'x $quantity', color: true)),
      ],
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "COD", child: Text("COD")),
    const DropdownMenuItem(value: "Paypal", child: Text("Paypal")),
  ];
  return menuItems;
}
