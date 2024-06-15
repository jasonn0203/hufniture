import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import thư viện cached_network_image
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/ui/screens/product_screen/product_detail/product_detail.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.productCard}) : super(key: key);
  final ProductCardModel productCard;

  @override
  Widget build(BuildContext context) {
    final vndCurrencyFormat = CurrencyFormatter.format(
        productCard.prodPrice, Helpers.currencySettings,
        decimal: 3);

    return GestureDetector(
      onTap: () => RouteConfig.navigateTo(context, const ProductDetail(),
          pageTransitionType: PageTransitionType.leftToRight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ColorConfig.secondaryColor,
                ),
                height: 120,
                width: double.infinity,
                child: CachedNetworkImage(
                  // Sử dụng CachedNetworkImage thay vì Image.network
                  imageUrl: productCard.prodImgUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  placeholder: (context, url) => const Center(
                    // Placeholder when load images
                    child: LoadingIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error), // Widget hiển thị khi có lỗi
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productCard.prodName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      productCard.shorDesc,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration:
                      const BoxDecoration(color: ColorConfig.primaryColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Format currency
                  vndCurrencyFormat,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
