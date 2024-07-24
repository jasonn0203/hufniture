// lib/ui/screens/home_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/helpers/banner_model.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/data/models/category.dart';
import 'package:hufniture/data/models/product_response.dart';
import 'package:hufniture/data/services/BannerService/banner_service.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:hufniture/ui/screens/product_screen/product_detail/product_detail.dart';
import 'package:hufniture/ui/widgets/category/category_home/category_home.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/product_card/product_card.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bannerService = BannerService();
    final listBanners = bannerService.getBanners();
    final bannerWidgets = _buildBannerWidgets(listBanners);

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Xin chào',
        isCenterTitle: false,
        isHomePage: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // Banner
            SliverToBoxAdapter(
              child: _buildBanner(bannerWidgets),
            ),
            // Category List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsSmall,
                    ),
                    const AppCustomText(
                      content: 'Danh Mục',
                      color: true,
                      isTitle: true,
                    )
                        .animate(
                            onComplete: (controller) => controller.repeat())
                        .shimmer(
                            delay: 200.ms,
                            duration: 1200.ms,
                            color: ColorConfig.secondaryColor,
                            angle: 60),
                    _buildCategoryList(),
                  ],
                ),
              ),
            ),
            // Hot Sales
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppCustomText(
                      content: 'Bán chạy nhất',
                      color: true,
                      isTitle: true,
                    )
                        .animate(
                            onComplete: (controller) => controller.repeat())
                        .shimmer(delay: 200.ms, duration: 1200.ms),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
                    ),
                    _buildHotSale(context),
                    SizedBox(
                      height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: _buildProductList(context),
      ),
    );
  }

  Padding _buildProductList(BuildContext context) {
    //final double screenWidth = ConstraintConfig.getWidth(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCustomText(
            content: 'Khám phá ngay !',
            color: true,
            isTitle: true,
          )
              .animate(onComplete: (controller) => controller.repeat())
              .shimmer(delay: 200.ms, duration: 1200.ms, angle: 60),
          SizedBox(
            height: ConstraintConfig.kSpaceBetweenItemsMedium,
          ),
          Expanded(
            child: FutureBuilder<List<ProductResults>>(
              future: ProductService.fetchRandomProductList(10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Lỗi khi tải lên danh sách sản phẩm'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Chưa có sản phẩm nào'));
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ConstraintConfig.responsive(context, 6, 4, 2),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 6,
                      mainAxisExtent: 330, // Adjust based on screen width
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return ProductCard(
                        productCard: ProductCardModel(
                          id: product.id!,
                          prodImgUrl: product.imageUrl!,
                          prodName: product.name!,
                          shorDesc: product.description!,
                          prodPrice: product.price!,
                        ),
                      );
                    },
                  ).animate(delay: 500.ms).fade(duration: 500.ms);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotSale(BuildContext context) {
    return FutureBuilder<ProductResults?>(
      future: ProductService.fetchBestSellingProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Lỗi khi tải sản phẩm bán chạy nhất'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Không có sản phẩm bán chạy nhất'));
        } else {
          final product = snapshot.data!;
          return Container(
            height: 132,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ColorConfig.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 26,
                  top: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ConstraintConfig.getWidth(context) > 400
                            ? 200
                            : 175,
                        child: Text(
                          product.name ?? '',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize:
                                        ConstraintConfig.getWidth(context) > 400
                                            ? 16
                                            : 12,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: ConstraintConfig.kSpaceBetweenItemsSmall,
                      ),
                      AppCustomText(
                        content: Helpers.formatPrice(product.price!),
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: ConstraintConfig.getWidth(context) > 400
                                  ? 16
                                  : 12,
                            ),
                      ),
                      SizedBox(
                        height: ConstraintConfig.kSpaceBetweenItemsMedium,
                      ),
                      SizedBox(
                        width: ConstraintConfig.getWidth(context) / 3,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            RouteConfig.navigateTo(
                                context,
                                ProductDetail(
                                    productId: product.id!,
                                    productName: product.name!));
                          },
                          child: Text(
                            'Mua Ngay',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 5,
                  top: -40,
                  child: CachedNetworkImage(
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingIndicator(),
                    imageUrl: product.imageUrl ?? '',
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(delay: 2000.ms, duration: 1800.ms) // shimmer +
                      .shake(hz: 2, curve: Curves.easeInOutCirc) // shake +
                      // scale up
                      .then(delay: 400.ms) // then wait and
                  ,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Padding _buildCategoryList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 70,
        child: FutureBuilder<List<FurnitureCategoryList>>(
          future: CategoryService.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: const Text('Lỗi'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có danh mục nào'));
            } else {
              final categories = snapshot.data!;
              return ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoryHome(category: categories[index]);
                },
              ).animate(delay: 400.ms).fade(duration: 500.ms);
            }
          },
        ),
      ),
    );
  }

  CarouselSlider _buildBanner(List<Widget> bannerWidgets) {
    return CarouselSlider(
      items: bannerWidgets,
      options: CarouselOptions(
        height: 120,
        viewportFraction: 0.8,
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
    );
  }

  List<Widget> _buildBannerWidgets(List<BannerModel> listBanners) {
    return listBanners.map((banner) {
      return CachedNetworkImage(
        imageUrl: banner.imgPath,
        fit: BoxFit.contain,
        placeholder: (context, url) => const LoadingIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }).toList();
  }
}
