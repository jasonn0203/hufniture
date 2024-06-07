import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';

import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/product_card/product_card.dart';

class CategoryByRoomScreen extends StatelessWidget {
  CategoryByRoomScreen({Key? key, required this.roomName}) : super(key: key);
  final String roomName;
  // Mock for test
  final List<String> subCate = [
    "Bàn Ăn",
    "Tủ Bếp",
    "Bàn Ăn",
    "Tủ Bếp",
    "Bàn Ăn",
  ];

  final ProductCardModel productCardModel = ProductCardModel(
      prodImgUrl:
          'https://www.pngall.com/wp-content/uploads/2016/06/Furniture-PNG-HD.png',
      prodName: 'Ghế Sofa',
      shorDesc: 'Ghế được làm bằng nhung, tạo cảm giác thoải mái',
      prodPrice: 150000);

  // Reponsive config
  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) {
      return 6; // Large screens
    } else if (screenWidth >= 800) {
      return 4; // Tablets
    } else {
      return 2; // Mobile devices
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: roomName),
      body: Column(
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
                labelStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
              tabBarViewProperties:
                  const TabBarViewProperties(physics: ClampingScrollPhysics()),
              tabs: _buildTabs(),
              views: subCate.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildViews(context),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildViews(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: SingleChildScrollView(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              mainAxisExtent: 290,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return ProductCard(productCard: productCardModel);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return subCate.map((category) => Tab(text: category)).toList();
  }
}
