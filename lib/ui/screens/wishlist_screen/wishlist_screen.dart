import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/models/product_response.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/product_screen/product_detail/product_detail.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:ionicons/ionicons.dart';

class WishlistScreen extends StatefulWidget {
  final ProductResults? addedProduct;

  const WishlistScreen({Key? key, this.addedProduct}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<ProductResults>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = _loadWishlist();
  }

  Future<List<ProductResults>> _loadWishlist() async {
    List<String> wishlistItemIds =
        await SharedPreferencesHelper.getWishlistItems();
    List<ProductResults> products = [];

    for (var id in wishlistItemIds) {
      ProductResults? product = await ProductService.fetchProductDetails(id);
      if (product != null) {
        // Check if the product is already in the list
        if (!products.any((p) => p.id == product.id)) {
          products.add(product);
        }
      }
    }

    if (widget.addedProduct != null) {
      // Only add the new product if it is not already in the list
      if (!products.any((p) => p.id == widget.addedProduct!.id)) {
        products.add(widget.addedProduct!);
      }
    }

    return products;
  }

  Future<void> _removeFromWishlist(String productId) async {
    List<String> wishlistItems =
        await SharedPreferencesHelper.getWishlistItems();
    wishlistItems.remove(productId);
    await SharedPreferencesHelper.saveWishlistItems(wishlistItems);
    setState(() {
      _wishlistFuture = _loadWishlist(); // Refresh wishlist
    });
  }

  void _navigateToProductDetail(ProductResults product) {
    RouteConfig.navigateTo(context,
        ProductDetail(productId: product.id!, productName: product.name!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Danh Sách Yêu Thích'),
      body: FutureBuilder<List<ProductResults>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load wishlist: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Danh sách yêu thích trống.'));
          } else {
            var wishlistItems = snapshot.data!;

            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                var product = wishlistItems[index];

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        onPressed: (context) =>
                            _removeFromWishlist(product.id!),
                        backgroundColor: ColorConfig.primaryColor,
                        foregroundColor: Colors.white,
                        icon: Ionicons.trash_bin,
                        label: 'Xóa',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 150,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: ColorConfig.secondaryColor,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl ?? '',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 150,
                              placeholder: (context, url) =>
                                  const LoadingIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Hero(
                              tag: product.id!,
                              child: const Icon(
                                Ionicons.heart,
                                color: ColorConfig.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      product.name!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () => _navigateToProductDetail(product),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
