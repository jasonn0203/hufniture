// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/services/ProductService/product_service.dart';
import 'package:hufniture/ui/screens/search_screen/search_result/search_result.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductService productService = ProductService();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  // Price value ( define later with api)
  final List<double> _priceSteps = [500000, 1000000, 1500000, 2000000];

  int _currentStepIndex = 0;
  double? minPrice;
  double? maxPrice;
  List<String> categoryIds = [];

  Future<List<FilterProduct>>? filteredProducts;
  List<Category>? categories;
  List<Color>? colors;
  // Replace with data in API
  final List<String> _categories = [];

  // A list of selected categories
  final Set<Category> _selectedCategories = {};

  // List of selectable colors
  // final List<Color> _selectableColors = [
  //   Colors.red,
  //   Colors.blue,
  //   Colors.green,
  //   Colors.yellow,
  //   Colors.orange,
  //   Colors.pink,
  // ];

  // Currently selected color
  // Color? _selectedColor;

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

  @override
  void initState() {
    super.initState();
    _loadFilterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Tìm Kiếm'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(context),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
            const AppCustomText(
              content: 'Được Tìm Nhiều Nhất',
              isTitle: true,
            ),
            SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
            Expanded(
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildMostSearchItem(context, 'Ghế');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            _showFilterSearch(context);
          },
          icon: const Icon(Ionicons.ellipsis_vertical),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        hintText: 'Tìm Kiếm',
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: ColorConfig.mainTextColor),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorConfig.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(18.0),
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorConfig.accentColor, width: 1),
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }

  TextButton _buildMostSearchItem(BuildContext context, String prodName) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: ColorConfig.secondaryColor,
        shape: const StadiumBorder(),
      ),
      child: Text(
        prodName,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onPressed: () {},
    );
  }

  Future<void> _showFilterSearch(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: ColorConfig.accentColor.withOpacity(0.2),
      context: context,
      builder: (context) => _buildFilterSheet(context),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: AppCustomText(
                  content: 'Bộ Lọc',
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorConfig.accentColor),
                ),
              ),
              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
              //_buildPriceRangeSlider(context, setModalState),
              AppCustomText(
                content: 'Khoảng Giá',
                textStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: ColorConfig.accentColor),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: minPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá thấp',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorFormatter(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: maxPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá cao',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorFormatter(),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
              _buildCategoryFilter(context, setModalState),
              // SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
              // _buildColorFilter(context, setModalState),
              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
              AppButton(
                text: 'Lọc',
                onPressed: () async {
                  //Lọc và load kết quả
                  final minPriceText =
                      minPriceController.text.replaceAll(RegExp(r'[^\d]'), '');
                  final maxPriceText =
                      maxPriceController.text.replaceAll(RegExp(r'[^\d]'), '');
                  final minPriceValue = double.tryParse(minPriceText);
                  final maxPriceValue = double.tryParse(maxPriceText);

                  // Lọc và load kết quả
                  final results = await productService.getFilteredProducts(
                    minPrice: minPriceValue,
                    maxPrice: maxPriceValue,
                    categoryIds:
                        _selectedCategories.map((cat) => cat.id).toList(),
                  );

                  // Điều hướng đến trang kết quả tìm kiếm với dữ liệu lọc
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResult(
                        filteredProducts: results,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceRangeSlider(
      BuildContext context, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          content: 'Khoảng Giá',
          textStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: ColorConfig.accentColor),
        ),
        Slider(
          value: _currentStepIndex.toDouble(),
          min: 0,
          max: (_priceSteps.length - 1).toDouble(),
          divisions: _priceSteps.length - 1,
          label: Helpers.formatPrice(_priceSteps[_currentStepIndex]).toString(),
          onChanged: (double value) {
            setModalState(() {
              _currentStepIndex = value.round();
            });
          },
          activeColor: ColorConfig.primaryColor,
          inactiveColor: ColorConfig.secondaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Helpers.formatPrice(_priceSteps[0]) as String),
            Text(Helpers.formatPrice(_priceSteps[_priceSteps.length - 1])
                as String),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          content: 'Danh Mục',
          textStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: ColorConfig.accentColor),
        ),
        const SizedBox(
          height: 4,
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 2.0,
          children: categories!.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              side: BorderSide.none,
              label: Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : ColorConfig.mainTextColor,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setModalState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              selectedColor: ColorConfig.primaryColor,
              backgroundColor: ColorConfig.secondaryColor,
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget _buildColorFilter(BuildContext context, StateSetter setModalState) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppCustomText(
  //         content: 'Màu Sắc',
  //         textStyle: Theme.of(context)
  //             .textTheme
  //             .titleSmall
  //             ?.copyWith(color: ColorConfig.accentColor),
  //       ),
  //       Wrap(
  //         spacing: 8.0,
  //         runSpacing: 8.0,
  //         children: _selectableColors.map((color) {
  //           return GestureDetector(
  //             onTap: () {
  //               setModalState(() {
  //                 // Toggle color selection
  //                 if (_selectedColor == color) {
  //                   _selectedColor = null;
  //                 } else {
  //                   _selectedColor = color;
  //                 }
  //               });
  //             },
  //             child: Container(
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: color,
  //                 border: Border.all(
  //                   color: _selectedColor == color
  //                       ? ColorConfig.primaryColor
  //                       : Colors.transparent,
  //                   width: 4.0,
  //                 ),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }
}

class ThousandsSeparatorFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    final numericString = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Convert to int and format
    final formattedString = _formatter.format(int.tryParse(numericString) ?? 0);

    // Add currency symbol 'đ'
    final newText = formattedString.isEmpty ? '' : '$formattedString đ';

    // Adjust cursor position
    final newSelection = TextSelection.collapsed(
      offset: newText.length,
    );

    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
}
