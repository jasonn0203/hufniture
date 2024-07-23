import 'dart:convert';

import 'package:hufniture/configs/environment.dart';
import 'package:http/http.dart' as http;
import 'package:hufniture/data/models/review_response.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';

class ReviewService {
  static Future<void> addReview(
      String productId, String userId, String content) async {
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(Environment.addReviewUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "furnitureProductId": productId,
        "userId": userId,
        "content": content,
        "createdAt": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response

      return;
    } else {
      throw Exception('Lỗi khi viết danh sách đánh giá');
    }
  }

  static Future<List<ReviewResponse>> getReviewsByProductId(
      String productId) async {
    try {
      final response = await http
          .get(Uri.parse(Environment.getReviewByProductId(productId)));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(response.body)['results'];
        return jsonResponse
            .map((review) => ReviewResponse.fromJson(review))
            .toList();
      } else {
        throw Exception(
            'Lỗi khi load danh sách đánh giá: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: Lỗi nè : $e');
      throw Exception('Lỗi khi load danh sách đánh giá');
    }
  }

  static Future<void> deleteReview(String reviewId) async {
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse(Environment.deleteReviewUrl(reviewId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      return;
    } else {
      throw Exception('Lỗi khi xóa đánh giá: ${response.body}');
    }
  }
}
