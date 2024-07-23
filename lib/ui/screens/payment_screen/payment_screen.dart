// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/helpers/cart_item.dart';
import 'package:hufniture/data/models/order_list_response.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/data/services/OrderService/order_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/payment_screen/payment_address_screen/payment_address_screen.dart';
import 'package:hufniture/ui/screens/payment_screen/payment_fail_screen/payment_fail_screen.dart';
import 'package:hufniture/ui/screens/payment_screen/payment_successful_screen/payment_successful_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key, required this.totalPrice, required this.cartItemsList});
  final double totalPrice;
  final List<CartItem> cartItemsList;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedValue = 'COD';
  String? userAddress;
  String? userPhoneNumber;
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await SharedPreferencesHelper.getUser();
    if (user == null) {
      debugPrint('Không tìm thấy thông tin người dùng.');
      return;
    }

    final userInfo = await _authService.getUserInfo(user['id']);
    if (userInfo != null) {
      setState(() {
        userAddress = userInfo['address'];
        userPhoneNumber = userInfo['phoneNumber'];
      });
    }
  }

  Future<void> _handlePayment() async {
    if (userAddress == null || userAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Durations.long4,
          content: Text(
              'Bạn cần cập nhật địa chỉ trước khi tiến hành thanh toán !!'),
        ),
      );
    } else {
      // Tiến hành quá trình thanh toán
      //Nếu thành công chuyển qua trang PaymentSuccessfulScreen, ngược lại thất bại thì chuyển sang PaymentFailScreen
      try {
        final success = await _orderService.placeOrder(widget.cartItemsList);
        if (success) {
          // Clear cart items
          await SharedPreferencesHelper.clearCartItems();

          RouteConfig.navigateTo(
            context,
            const PaymentSuccessfulScreen(),
          );
        } else {
          RouteConfig.navigateTo(context, const PaymentFailScreen());
        }
      } catch (e) {
        RouteConfig.navigateTo(context, const PaymentFailScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = ConstraintConfig.getWidth(context);
    final double screenHeight = ConstraintConfig.getHeight(context);
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
                          context,
                          PaymentAddressScreen(
                            onUpdateAddress: _loadUserInfo,
                            initialAddress: userAddress,
                          ));
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
                padding: EdgeInsets.all(screenWidth * 0.03),
                width: screenWidth * 0.9,
                height: screenHeight * 0.14,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(screenWidth * 0.06)),
                  color: ColorConfig.secondaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Ionicons.location_outline),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        Expanded(
                          child: Text(
                            userAddress ?? 'Chưa có địa chỉ',
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Ionicons.call_outline),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        Text(
                          userPhoneNumber ?? 'Chưa có số điện thoại',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
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
                  for (final item in widget.cartItemsList)
                    _buildOrderItem(item),
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
              AppButton(text: 'Thanh Toán Ngay', onPressed: _handlePayment),
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
          content: Helpers.formatPrice(widget.totalPrice).toString(),
          isTitle: true,
        )
      ],
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
        Expanded(
            child: AppCustomText(content: 'x ${item.quantity}', color: true)),
      ],
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "COD", child: Text("COD")),
      const DropdownMenuItem(value: "Paypal", child: Text("Paypal")),
    ];
    return menuItems;
  }
}
