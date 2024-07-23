import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/models/filter_product.dart';

class SearchService {
  static Future<List<FilterProduct>> getFilteredProducts({
    double? minPrice,
    double? maxPrice,
    List<String>? categoryIds,
    List<String>? colorIds,
  }) async {
    final Uri uri =
        Uri.parse(Environment.filterProductUrl).replace(queryParameters: {
      if (minPrice != null) 'MinPrice': minPrice.toString(),
      if (maxPrice != null) 'MaxPrice': maxPrice.toString(),
      if (categoryIds != null && categoryIds.isNotEmpty)
        'CategoryIds': categoryIds.join(','),
      if (colorIds != null && colorIds.isNotEmpty)
        'ColorIds': colorIds.join(','),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => FilterProduct.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load filtered products');
    }
  }
}
