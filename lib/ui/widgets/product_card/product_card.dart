import 'package:flutter/material.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.productCard}) : super(key: key);
  final ProductCardModel productCard;

  @override
  Widget build(BuildContext context) {
    final vndCurrencyFormat = "${productCard.prodPrice.toStringAsFixed(0)} VND";

    return GestureDetector(
      onTap: () {
        // Navigate to product details or perform other actions
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
                child: CircularProgressIndicator(),
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Text(
                  productCard.shorDesc,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8.0),
                Text(
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
