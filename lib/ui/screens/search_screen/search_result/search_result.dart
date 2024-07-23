import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:hufniture/ui/screens/product_screen/product_detail/product_detail.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class SearchResult extends StatefulWidget {
  final List<FilterProduct> filteredProducts;

  const SearchResult({
    Key? key,
    required this.filteredProducts,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  String _selectedSortOption = 'Giá từ thấp đến cao';
  bool _isGridView = false; // Track the view mode

  List<FilterProduct> get sortedProducts {
    List<FilterProduct> sortedList = List.from(widget.filteredProducts);
    switch (_selectedSortOption) {
      case 'Giá từ thấp đến cao':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Giá từ cao đến thấp':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Từ A-Z':
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Kết Quả Tìm Kiếm'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildSortDropdown(),
            Expanded(
              child: sortedProducts.isNotEmpty
                  ? _isGridView
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  mainAxisExtent: 220,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4),
                          itemCount: sortedProducts.length,
                          itemBuilder: (context, index) {
                            final product = sortedProducts[index];
                            return _buildGridItem(product);
                          },
                        )
                      : ListView.builder(
                          itemCount: sortedProducts.length,
                          itemBuilder: (context, index) {
                            final product = sortedProducts[index];
                            return _buildListItem(product);
                          },
                        )
                  : const Center(child: Text('Không có kết quả nào')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sắp xếp theo:',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: DropdownButton<String>(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              elevation: 2,
              value: _selectedSortOption,
              isExpanded: true,
              items: <String>[
                'Giá từ thấp đến cao',
                'Giá từ cao đến thấp',
                'Từ A-Z'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSortOption = newValue!;
                });
              },
            ),
          ),
          _buildViewToggle(),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(FilterProduct product) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              product.imageURL,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: GestureDetector(
              onTap: () => RouteConfig.navigateTo(
                  context,
                  ProductDetail(
                      productId: product.id, productName: product.name)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    Helpers.formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(FilterProduct product) {
    return GestureDetector(
      onTap: () => RouteConfig.navigateTo(context,
          ProductDetail(productId: product.id, productName: product.name)),
      child: Card(
        elevation: 1,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                product.imageURL,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: ColorConfig.accentColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    Helpers.formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: ColorConfig.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
