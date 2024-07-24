// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/helpers/cart_item.dart';
import 'package:hufniture/data/models/product_response.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/product_screen/product_review/product_review.dart';
import 'package:hufniture/ui/screens/wishlist_screen/wishlist_screen.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/configs/toast_manager.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {Key? key, required this.productId, required this.productName})
      : super(key: key);

  final String productId;
  final String productName;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<ProductResults?> _productFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProductDetails(widget.productId);
    _checkIfFavorite(); // Check if the product is already in the wishlist
  }

  void _checkIfFavorite() async {
    List<String> wishlistItems =
        await SharedPreferencesHelper.getWishlistItems();
    setState(() {
      _isFavorite = wishlistItems.contains(widget.productId);
    });
  }

  Future<void> _toggleFavorite(ProductResults product) async {
    List<String> wishlistItems =
        await SharedPreferencesHelper.getWishlistItems();

    if (_isFavorite) {
      // Remove from wishlist
      wishlistItems.remove(product.id);
      await SharedPreferencesHelper.saveWishlistItems(wishlistItems);
      ToastManager.showSuccessToast(
          context, 'Xóa thành công!', 'Đã xóa ra khỏi wishlist!');
    } else {
      // Add to wishlist only if it is not already in the list
      if (!wishlistItems.contains(product.id)) {
        wishlistItems.add(product.id!);
        await SharedPreferencesHelper.saveWishlistItems(wishlistItems);
        ToastManager.showSuccessToast(
            context, 'Thêm thành công!', 'Thêm vào wishlist thành công!');
      }
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishlistScreen(
            addedProduct: product,
          ),
        ),
      );
    }
  }

  Future<void> _addToCart(ProductResults product) async {
    List<CartItem> cartItems = await SharedPreferencesHelper.getCartItems();

    bool isInCart = cartItems.any((item) => item.id == product.id);

    if (isInCart) {
      cartItems = cartItems.map((item) {
        if (item.id == product.id) {
          item.quantity += 1;
        }
        return item;
      }).toList();
    } else {
      cartItems.add(CartItem(
        id: product.id!,
        image: product.imageUrl ?? '',
        name: product.name ?? '',
        price: product.price!,
        quantity: 1,
      ));
    }

    await SharedPreferencesHelper.saveCartItems(cartItems);

    ToastManager.showSuccessToast(
        context, 'Thêm vào giỏ hàng', 'Đã thêm sản phẩm vào giỏ hàng !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.productName),
      body: FutureBuilder<ProductResults?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Failed to load product details: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No product details available'));
          } else {
            var product = snapshot.data!;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: double.infinity,
                          height: ConstraintConfig.getHeight(context) * 0.31,
                          decoration: const BoxDecoration(
                            color: ColorConfig.secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Hero(
                                tag: product.imageUrl!.toString().toLowerCase(),
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const LoadingIndicator(),
                                  imageUrl: product.imageUrl ?? '',
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                                    .animate()
                                    .scaleX(
                                        duration: 450.ms,
                                        alignment: Alignment.centerLeft,
                                        curve: Curves.easeInOutCirc)
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat()) // shake +
                                    // scale up
                                    .shimmer(
                                        delay: 2000.ms,
                                        duration: 1800.ms) // shimmer +

                                    .then(delay: 400.ms) // then wait and,
                                ),
                          ),
                        ),
                        SizedBox(
                            height: ConstraintConfig.kSpaceBetweenItemsMedium),
                        Text(
                          product.name ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                            height: ConstraintConfig.kSpaceBetweenItemsMedium),
                        Text(
                          product.description ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                            height: ConstraintConfig.kSpaceBetweenItemsMedium),
                        Container(
                          margin: const EdgeInsets.only(top: 32, bottom: 16),
                          width: double.infinity,
                          height: 2,
                          color: ColorConfig.primaryColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppCustomText(
                              content: Helpers.formatPrice(product.price!),
                              color: true,
                              isTitle: true,
                            ),
                            Hero(
                              tag: product.id!,
                              child: IconButton(
                                tooltip: 'Thêm vào yêu thích',
                                onPressed: () => _toggleFavorite(product),
                                icon: _isFavorite
                                    ? const Icon(Ionicons.heart,
                                        color: ColorConfig.primaryColor)
                                    : const Icon(Ionicons.heart_outline),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: ConstraintConfig.kSpaceBetweenItemsSmall),
                        InkWell(
                          onTap: () {
                            // Navigate to Product Review
                            RouteConfig.navigateTo(
                                context, ProductReview(productId: product.id!));
                          },
                          child: const Text('Xem đánh giá'),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppButton(
                      text: 'Thêm Vào Giỏ',
                      onPressed: () => _addToCart(product),
                      width: ConstraintConfig.getWidth(context) / 2,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0)} VND";
  }
}
