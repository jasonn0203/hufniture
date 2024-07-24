import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/models/product_response.dart';

class ProductService {
  static Future<ProductResults?> fetchProductDetails(String id) async {
    final url = Uri.parse(Environment.furnitureProductDetailUrl(id));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productDetails = ProductResponse.fromJson(jsonData);
      return productDetails.results;
    } else {
      throw Exception('Lỗi khi load sản phẩm !');
    }
  }

  static Future<List<ProductResults>> fetchRandomProductList(int take) async {
    final url = Uri.parse(Environment.getRandomProductList(take));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Chuyển đổi từ JSON thành danh sách sản phẩm
      final List<dynamic> productsJson = jsonData['results'];
      return productsJson.map((json) => ProductResults.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi load danh sách sản phẩm');
    }
  }

  static Future<ProductResults?> fetchBestSellingProduct() async {
    final url = Uri.parse(Environment.bestSellingProductUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productDetails = ProductResponse.fromJson(jsonData);
      return productDetails.results;
    } else {
      throw Exception('Failed to load best selling product');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse(Environment.furnitureCategoryUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoriesData = data['results'];
        return categoriesData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load categories');
    }
  }

  Future<List<FilterProduct>> getFilteredProducts({
    double? minPrice,
    double? maxPrice,
    List<String>? categoryIds,
    List<String>? colorIds,
  }) async {
    try {
      // Construct query parameters
      final Map<String, List<String>> queryParameters = {};
      if (minPrice != null) {
        queryParameters['minPrice'] = [minPrice.toString()];
      }
      if (maxPrice != null) {
        queryParameters['maxPrice'] = [maxPrice.toString()];
      }
      if (categoryIds != null && categoryIds.isNotEmpty) {
        queryParameters['categoryIds'] = categoryIds;
      }
      if (colorIds != null && colorIds.isNotEmpty) {
        queryParameters['colorIds'] = colorIds;
      }

      // Manually build query string to ensure multiple 'categoryIds' are included correctly
      final Uri uri = Uri.parse(
              'https://localhost:7245/api/FurnitureProduct/GetFilteredProducts')
          .replace(
              queryParameters: queryParameters
                  .map((key, values) => MapEntry(key, values.join(','))));

      final queryString = uri.queryParameters.entries
          .expand((entry) => entry.value.split(',').map((value) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(value)}'))
          .join('&');

      final fullUri = uri.replace(query: queryString);

      // Make the HTTP GET request
      final response = await http.get(fullUri);

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsData = data['results'];
        return productsData
            .map((json) => FilterProduct.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to load products');
    }
  }
}

class FilterProduct {
  final String id;
  final String name;
  final String imageURL;
  final double price;
  final String categoryId;
  final Color color; // Adjust this according to your API response
  final Category category; // Adjust this according to your API response

  FilterProduct(
      {required this.id,
      required this.name,
      required this.price,
      required this.categoryId,
      required this.color,
      required this.category,
      required this.imageURL});

  factory FilterProduct.fromJson(Map<String, dynamic> json) {
    return FilterProduct(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      categoryId: json['furnitureCategoryId'],
      color: Color.fromJson(json['color']),
      category: Category.fromJson(json['furnitureCategory']),
      imageURL: json['imageURL'],
    );
  }
}

class Color {
  final String id;
  final String name;

  Color({
    required this.id,
    required this.name,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
