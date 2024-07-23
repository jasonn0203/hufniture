import 'package:flutter/material.dart';
import 'package:hufniture/data/models/category.dart';
import 'package:hufniture/data/services/CategoryService/category_service.dart';
import 'package:hufniture/ui/screens/category/category_by_room_screen/category_room_by_name_type.dart';
import 'package:hufniture/ui/widgets/category/category_grid/category_grid.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<FurnitureCategoryList>> _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = CategoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Scaffold(
          appBar: const CustomAppbar(title: 'Danh Mục Phòng'),
          body: FutureBuilder<List<FurnitureCategoryList>>(
            future: _categoryFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Ensure no null values are included in the list
                List<FurnitureCategoryList> categories = snapshot.data!
                    .where((category) => category.name != null)
                    .toList();

                return CategoryGrid(
                  item: categories.map((category) => category.name).toList(),
                  function: (String room) {
                    FurnitureCategoryList selectedCategory = categories
                        .firstWhere((category) => category.name == room);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryRoomByNameTypeScreen(
                          categoryId: selectedCategory.id,
                          categoryName: selectedCategory.name,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load categories: ${snapshot.error}'),
                );
              }
              // By default, show a loading spinner
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
