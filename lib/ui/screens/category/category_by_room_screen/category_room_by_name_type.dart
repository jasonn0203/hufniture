import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/data/models/category_products_witth_type.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/product_card/product_card.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';

class CategoryRoomByNameTypeScreen extends StatefulWidget {
  const CategoryRoomByNameTypeScreen(
      {super.key, this.categoryId, required this.categoryName});
  final String? categoryId;
  final String categoryName;

  @override
  State<CategoryRoomByNameTypeScreen> createState() =>
      _CategoryRoomByNameTypeScreenState();
}

class _CategoryRoomByNameTypeScreenState
    extends State<CategoryRoomByNameTypeScreen> {
  late Future<CategoryProductWithTypeList?> _categoryFuture;
  bool _isGridView = true; // Thêm biến trạng thái

  @override
  void initState() {
    super.initState();
    _categoryFuture = CategoryService.fetchCategoryDetails(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.categoryName),
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
                // Thêm ToggleButton với highlight mode hiện tại
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppCustomText(
                        content: 'Chế độ xem',
                        color: true,
                      ),
                      Row(
                        children: [
                          _buildToggleButton(
                            icon: Ionicons.grid,
                            isSelected: _isGridView,
                            onPressed: () {
                              setState(() {
                                _isGridView = true;
                              });
                            },
                          ),
                          _buildToggleButton(
                            icon: Ionicons.list,
                            isSelected: !_isGridView,
                            onPressed: () {
                              setState(() {
                                _isGridView = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // Thêm key duy nhất để đảm bảo hoạt ảnh
              key: ValueKey<bool>(_isGridView),
              child: _isGridView
                  ? _buildProductGridView(type.products, context)
                  : _buildProductListView(type.products, context),
            ),
          );
        }).toList() ??
        [];
  }

  Widget _buildProductGridView(List<Products>? products, BuildContext context) {
    return GridView.builder(
      key: ValueKey<bool>(_isGridView), // Thêm key duy nhất
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
    ).animate(delay: 300.ms).fade(duration: 400.ms);
  }

  Widget _buildProductListView(List<Products>? products, BuildContext context) {
    return ListView.builder(
      key: ValueKey<bool>(_isGridView), // Thêm key duy nhất
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
    ).animate(delay: 300.ms).fade(duration: 400.ms);
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isSelected ? ColorConfig.accentColor : Colors.transparent,
        ),
        child: IconButton(
          style: TextButton.styleFrom(
            primary: isSelected ? Colors.white : ColorConfig.primaryColor,
          ),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
