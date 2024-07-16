import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/models/category.dart';
import 'package:hufniture/data/models/category_products_witth_type.dart';

class CategoryService {
  static Future<List<FurnitureCategoryList>> fetchCategories() async {
    final url = Uri.parse('${Environment.apiUrl}/FurnitureCategory');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final furnitureCategory = FurnitureCategory.fromJson(jsonData);
      return furnitureCategory.results ?? [];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<CategoryProductWithTypeList?> fetchCategoryDetails(
      String? id) async {
    final url = Uri.parse(Environment.furnitureCategoryProductUrl(id!));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoryDetails = CategoryProductWithType.fromJson(jsonData);
      return categoryDetails.results;
    } else {
      throw Exception('Failed to load category details');
    }
  }
}
