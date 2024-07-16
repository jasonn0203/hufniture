import 'dart:js';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/data/models/category_products_witth_type.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/product_card/product_card.dart';

class CategoryRoomByNameTypeScreen extends StatefulWidget {
  const CategoryRoomByNameTypeScreen({super.key, this.categoryId});
  final String? categoryId;
  @override
  State<CategoryRoomByNameTypeScreen> createState() =>
      _CategoryRoomByNameTypeScreenState();
}

class _CategoryRoomByNameTypeScreenState
    extends State<CategoryRoomByNameTypeScreen> {
  late Future<CategoryProductWithTypeList?> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = CategoryService.fetchCategoryDetails(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Phòng'),
      body: FutureBuilder<CategoryProductWithTypeList?>(
        future: _categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load data: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            var categoryDetails = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ContainedTabBarView(
                    initialIndex: 0,
                    tabBarProperties: const TabBarProperties(
                      indicatorColor: ColorConfig.primaryColor,
                      isScrollable: true,
                      unselectedLabelColor: ColorConfig.accentColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelColor: ColorConfig.primaryColor,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                    tabBarViewProperties: const TabBarViewProperties(
                        physics: ClampingScrollPhysics()),
                    tabs: _buildTabs(categoryDetails),
                    views: _buildViews(categoryDetails, context),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

List<Widget> _buildTabs(CategoryProductWithTypeList categoryDetails) {
  return categoryDetails.furnitureTypes?.map((type) {
        return Tab(text: type.typeName ?? '');
      }).toList() ??
      [];
}

List<Widget> _buildViews(
    CategoryProductWithTypeList categoryDetails, BuildContext context) {
  return categoryDetails.furnitureTypes?.map((type) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProductGridView(type.products, context),
        );
      }).toList() ??
      [];
}

Widget _buildProductGridView(List<Products>? products, BuildContext context) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: ConstraintConfig.responsive(context, 6, 4, 2),
      crossAxisSpacing: 8,
      mainAxisSpacing: 6,
      mainAxisExtent: 330,
    ),
    itemCount: products?.length ?? 0,
    itemBuilder: (context, index) {
      var product = products![index];
      return ProductCard(
        productCard: ProductCardModel(
          id: product.id,
          prodImgUrl: product.imageURL,
          prodName: product.name,
          shorDesc: product.description,
          prodPrice: product.price,
        ),
      );
    },
  );
}
