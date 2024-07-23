import 'package:flutter/material.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class ProductFilterScreen extends StatefulWidget {
  const ProductFilterScreen({super.key});

  @override
  _ProductFilterScreenState createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  final ProductService productService = ProductService();

  double? minPrice;
  double? maxPrice;
  List<String> categoryIds = [];

  Future<List<FilterProduct>>? filteredProducts;
  List<Category>? categories;
  List<Color>? colors;

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    try {
      final fetchedCategories = await productService.getCategories();

      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print(e);
    }
  }

  void _applyFilters() {
    setState(() {
      minPrice = double.tryParse(minPriceController.text);
      maxPrice = double.tryParse(maxPriceController.text);
      filteredProducts = productService.getFilteredProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        categoryIds: categoryIds,
      );
    });
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Price inputs
            TextField(
              controller: minPriceController,
              decoration: InputDecoration(labelText: 'Minimum Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxPriceController,
              decoration: InputDecoration(labelText: 'Maximum Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Category selection
            categories == null
                ? const CircularProgressIndicator()
                : MultiSelectDialogField<String>(
                    items: categories!
                        .map((category) =>
                            MultiSelectItem<String>(category.id, category.name))
                        .toList(),
                    title: Text('Select Categories'),
                    selectedColor: Colors.blue,
                    onConfirm: (values) {
                      setState(() {
                        categoryIds = values;
                      });
                    },
                  ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
            Expanded(
              child: FutureBuilder<List<FilterProduct>>(
                future: filteredProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('\$${product.price}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
