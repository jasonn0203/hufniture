import 'package:flutter/material.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hufniture/ui/screens/product_screen/product_detail/product_detail.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.productCard}) : super(key: key);
  final ProductCardModel productCard;

  @override
  Widget build(BuildContext context) {
    final screenWidth = ConstraintConfig.getWidth(context);

    return GestureDetector(
      onTap: () {
        // Navigate to product details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              productId: productCard.id,
              productName: productCard.prodName,
            ),
          ),
        );
      },
      child: Column(
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
              imageUrl: productCard.prodImgUrl,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              placeholder: (context, url) => const Center(
                child: LoadingIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productCard.prodName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: screenWidth > 300 ? 18 : 12),
                ),
                const SizedBox(height: 8.0),
                Text(
                  productCard.shorDesc,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8.0),
                AppCustomText(
                  content: Helpers.formatPrice(
                    productCard.prodPrice,
                  ),
                  color: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
