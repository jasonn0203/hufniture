import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/toast_manager.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/text/body/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Ghế Sofa'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    height: ConstraintConfig.getHeight(context) * 0.31,
                    decoration: const BoxDecoration(
                      color: ColorConfig.secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const LoadingIndicator(),
                        imageUrl:
                            'https://static.vecteezy.com/system/resources/previews/009/858/141/original/rose-gold-sofa-3d-illustration-empty-2-seats-luxury-sofa-png.png',
                      ),
                    ),
                  ),
                  SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                  // Product Name
                  const AppCustomText(
                    content: 'Ghế Sofa',
                    isTitle: true,
                  ),
                  SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                  // Product desc
                  AppCustomText(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    content:
                        'Kiểu dáng thiết kế của sofa Bolero tuy đơn giản nhưng lại mang đến sự tinh tế cho không gian phòng khách còn là sản phẩm sofa đáng sở hữu bởi thiết kế và trải nghiệm sử dụng.',
                  ),
                  SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                  Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 16),
                    width: double.infinity,
                    height: 2,
                    color: ColorConfig.primaryColor,
                  ),
                  // Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Replace actual price later
                      AppCustomText(
                        isTitle: true,
                        content: _formatPrice(250000),
                      ),
                      IconButton(
                          tooltip: 'Thêm vào yêu thích',
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                              // Add successful toast
                              ToastManager.showSuccessToast(
                                  context,
                                  'Thành công !',
                                  'Thêm vào yêu thích thành công');
                            });
                          },
                          icon: _isFavorite
                              ? const Icon(
                                  Ionicons.heart,
                                  color: ColorConfig.primaryColor,
                                )
                              : const Icon(Ionicons.heart_outline))
                    ],
                  ),
                  SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AppButton(
                text: 'Thêm vào giỏ',
                onPressed: () {
                  ToastManager.showSuccessToast(
                      context, 'Thành công !', 'Thêm vào giỏ hàng thành công');
                },
                width: ConstraintConfig.getWidth(context) / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return CurrencyFormatter.format(price, Helpers.currencySettings,
        decimal: 3);
  }
}
