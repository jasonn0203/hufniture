import 'package:flutter/material.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/data/models/category_products_witth_type.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class CategoryProductWithTypeScreen extends StatefulWidget {
  final String? categoryId;

  const CategoryProductWithTypeScreen({Key? key, required this.categoryId})
      : super(key: key);

  @override
  _CategoryProductWithTypeScreenState createState() =>
      _CategoryProductWithTypeScreenState();
}

class _CategoryProductWithTypeScreenState
    extends State<CategoryProductWithTypeScreen> {
  late Future<CategoryProductWithTypeList?> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = CategoryService.fetchCategoryDetails(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Danh sách sản phẩm'),
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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ConstraintConfig.responsive(context, 6, 4, 2),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 290,
                ),
                itemCount: categoryDetails.furnitureTypes?.length ?? 0,
                itemBuilder: (context, index) {
                  var furnitureType = categoryDetails.furnitureTypes![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          furnitureType.typeName ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: furnitureType.products?.length ?? 0,
                        itemBuilder: (context, index) {
                          var product = furnitureType.products![index];
                          return ListTile(
                            leading: Image.network(
                              product.imageURL,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.name),
                            subtitle: Text(product.description),
                            trailing: Text('${product.price} đ'),
                            onTap: () {
                              // Handle tapping on product
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
