import 'package:flutter/material.dart';
import 'package:hufniture/data/models/filter_product.dart';
import 'package:hufniture/data/services/SearchService/search_service.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double? minPrice;
  double? maxPrice;
  List<String> selectedCategories = [];
  List<String> selectedColors = [];

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
            TextField(
              decoration: InputDecoration(labelText: 'Min Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                minPrice = double.tryParse(value);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Max Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                maxPrice = double.tryParse(value);
              },
            ),
            // Widget chọn danh mục
            MultiSelectChip(
              items: ['Living Room', 'Bedroom', 'Office'],
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedCategories = selectedList;
                });
              },
            ),
            // Widget chọn màu sắc
            MultiSelectChip(
              items: ['Red', 'Blue', 'Green'],
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedColors = selectedList;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                fetchFilteredProducts();
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchFilteredProducts() async {
    try {
      List<FilterProduct> products = await SearchService.getFilteredProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        categoryIds: selectedCategories,
        colorIds: selectedColors,
      );
      // Xử lý danh sách sản phẩm ở đây
    } catch (e) {
      print('Error: $e');
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip({required this.items, required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.items.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
