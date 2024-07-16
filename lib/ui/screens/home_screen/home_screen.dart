// lib/ui/screens/home_screen.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/helpers/banner_model.dart';
import 'package:hufniture/data/models/category.dart';
import 'package:hufniture/data/services/BannerService/banner_service.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/ui/widgets/category/category_home/category_home.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            _buildBanner(bannerWidgets),

            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsSmall,
            ),
            // Category List
            const AppCustomText(
              content: 'Danh Mục',
              color: true,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            // Category List
            _buildCategoryList(),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            // Hot Sales
            const AppCustomText(
              content: 'Bán chạy nhất',
              color: true,
            ),

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
    );
  }

  Container _buildHotSale(BuildContext context) {
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
                AppCustomText(
                  content: 'Tủ Bếp',
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: ColorConfig.secondaryColor),
                ),
                SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
                ),
                SizedBox(
                  width: ConstraintConfig.getWidth(context) / 3,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {},
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
            right: 10,
            top: -40,
            child: Image.asset(
              '${Helpers.imgUrl}/kitchen_cart_2.png',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildCategoryList() {
    return SizedBox(
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
            );
          }
        },
      ),
    );
  }

  CarouselSlider _buildBanner(List<Widget> bannerWidgets) {
    return CarouselSlider(
      items: bannerWidgets,
      options: CarouselOptions(
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOutCirc,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  List<Widget> _buildBannerWidgets(List<BannerModel> banners) {
    return banners.map((banner) {
      return Image.asset(banner.imgPath,
          fit: BoxFit.contain, width: double.infinity);
    }).toList();
  }
}
