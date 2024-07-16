import 'package:flutter/material.dart';
import 'package:hufniture/data/helpers/product_card_model.dart';
import 'package:hufniture/data/models/category_products_witth_type.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';

import 'package:hufniture/ui/widgets/product_card/product_card.dart';

class CategoryByRoomScreen extends StatefulWidget {
  final String roomName;

  const CategoryByRoomScreen({Key? key, required this.roomName})
      : super(key: key);

  @override
  _CategoryByRoomScreenState createState() => _CategoryByRoomScreenState();
}

class _CategoryByRoomScreenState extends State<CategoryByRoomScreen> {
  late Future<CategoryProductWithTypeList?> _categoryProductsFuture;

  @override
  void initState() {
    super.initState();
    _categoryProductsFuture =
        CategoryService.fetchCategoryDetails(widget.roomName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: FutureBuilder<CategoryProductWithTypeList?>(
        future: _categoryProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.furnitureTypes == null ||
              snapshot.data!.furnitureTypes!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return _buildTabView(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildTabView(CategoryProductWithTypeList data) {
    return DefaultTabController(
      length: data.furnitureTypes!.length,
      child: Column(
        children: [
          TabBar(
            tabs: data.furnitureTypes!
                .map((type) => Tab(text: type.typeName ?? ''))
                .toList(),
            isScrollable: true,
          ),
          Expanded(
            child: TabBarView(
              children: data.furnitureTypes!.map((type) {
                return _buildProductGridView(type.products);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridView(List<Products>? products) {
    if (products == null || products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    // Convert List<Products> to List<ProductCardModel>
    List<ProductCardModel> productCardModels = products.map((product) {
      return ProductCardModel(
        id: product.id,
        prodName: product.name,
        prodImgUrl: product.imageURL,
        shorDesc: product.description,
        prodPrice: product.price,
      );
    }).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: productCardModels.length,
      itemBuilder: (context, index) {
        return ProductCard(productCard: productCardModels[index]);
      },
    );
  }
}
