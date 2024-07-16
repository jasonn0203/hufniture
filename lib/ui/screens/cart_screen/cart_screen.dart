import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/helpers/cart_item.dart';
import 'package:hufniture/ui/screens/payment_screen/payment_screen.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItemsList = [
    CartItem(
        id: 1,
        image: '${Helpers.imgUrl}/kitchen_cart_2.png',
        name: 'Kệ bếp',
        price: 200000.0,
        quantity: 1),
    CartItem(
        id: 2,
        image: '${Helpers.imgUrl}/kitchen_cart.png',
        name: 'Ghế Sofa Bolero',
        price: 420000.0,
        quantity: 1),
    CartItem(
        id: 3,
        image: '${Helpers.imgUrl}/kitchen_cart_2.png',
        name: 'Kệ bếp',
        price: 246000.0,
        quantity: 1),
  ];

  void updateCartQuantity(int index, int newQuantity) => setState(() {
        cartItemsList[index].quantity = newQuantity;
      });

  void deleteCartItem(int id) => setState(() {
        cartItemsList.removeWhere((item) => item.id == id);
      });

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItemsList) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    double shippingFee = 25000.0; // Mock data
    double grandTotal = totalPrice + shippingFee;

    return Scaffold(
      appBar: const CustomAppbar(title: 'Giỏ Hàng'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: cartItemsList.isEmpty
            ? _buildCartEmpty()
            : _buildCartItemsList(totalPrice, shippingFee, grandTotal),
      ),
    );
  }

  Center _buildCartEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('${Helpers.imgUrl}/cart_empty.png'),
          SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
          const AppCustomText(
            content: 'Không có sản phẩm nào',
            isTitle: true,
          ),
        ],
      ),
    );
  }

  Column _buildCartItemsList(
      double totalPrice, double shippingFee, double grandTotal) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                cartItemsList.clear();
              });
            },
            child: const Icon(
              Ionicons.trash_bin,
              color: ColorConfig.primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
        ),
        Expanded(
          flex: 4,
          child: ListView.builder(
            itemCount: cartItemsList.length,
            itemBuilder: (context, index) {
              final item = cartItemsList[index];
              return _buildSingleCartItem(item, context, index);
            },
          ),
        ),

        // Price
        const Spacer(),
        Column(
          children: [
            Container(
              height: 2,
              color: ColorConfig.primaryColor,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppCustomText(
                  content: 'Tạm Tổng',
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorConfig.accentColor,
                      fontWeight: FontWeight.normal),
                ),
                AppCustomText(
                    content: Helpers.formatPrice(totalPrice).toString()),
              ],
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppCustomText(
                  content: 'Phí Giao Hàng',
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorConfig.accentColor,
                      fontWeight: FontWeight.normal),
                ),
                AppCustomText(content: Helpers.formatPrice(shippingFee)),
              ],
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Container(
              height: 2,
              color: ColorConfig.primaryColor,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppCustomText(
                  content: 'Tổng Cộng',
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorConfig.accentColor,
                      ),
                ),
                AppCustomText(
                  content: Helpers.formatPrice(grandTotal),
                  textStyle: const TextStyle(
                      color: ColorConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ],
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsLarge,
            ),
            AppButton(
                text: 'Thanh Toán',
                onPressed: () {
                  // Handle checkout
                  RouteConfig.navigateTo(
                      context,
                      PaymentScreen(
                        totalPrice: grandTotal,
                      ));
                })
          ],
        )
      ],
    );
  }

  Slidable _buildSingleCartItem(
      CartItem item, BuildContext context, int index) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              deleteCartItem(item.id);
            },
            backgroundColor: ColorConfig.primaryColor,
            foregroundColor: Colors.white,
            icon: Ionicons.trash_bin,
            label: 'Xóa',
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(
          item.image,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
        title: Text(item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(Helpers.formatPrice(item.price).toString(),
            style: Theme.of(context).textTheme.bodySmall),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: ColorConfig.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                alignment: Alignment.center,
                icon: const Icon(
                  Ionicons.remove,
                  color: ColorConfig.accentColor,
                  size: 10,
                ),
                onPressed: () {
                  if (item.quantity > 1) {
                    updateCartQuantity(index, item.quantity - 1);
                  }
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${item.quantity}')),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: ColorConfig.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                alignment: Alignment.center,
                icon: const Icon(
                  Ionicons.add,
                  color: ColorConfig.secondaryColor,
                  size: 10,
                ),
                onPressed: () {
                  updateCartQuantity(index, item.quantity + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
