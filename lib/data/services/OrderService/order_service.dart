import 'dart:convert';

import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/helpers/cart_item.dart';
import 'package:hufniture/data/models/order_list_response.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<bool> placeOrder(List<CartItem> cartItems) async {
    try {
      final user = await SharedPreferencesHelper.getUser();
      if (user == null) {
        throw Exception('User not found');
      }

      final token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) {
        print('Không tìm thấy token xác thực.');
      }

      final orderItems = cartItems
          .map((item) => {
                'productId': item.id,
                'quantity': item.quantity,
              })
          .toList();

      print('Đơn hàng gửi đi: ${jsonEncode({
            'userId': user['id'],
            'items': orderItems,
          })}');

      final response = await http.post(
        Uri.parse(Environment.placeOrder),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': user['id'],
          'items': orderItems,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Lỗi khi đặt hàng: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi đặt hàng: $e');
      return false;
    }
  }

  Future<List<Order>> getOrdersByUserId(String userId) async {
    try {
      final token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final response = await http.get(
        Uri.parse(Environment.getOrderListByUserId(userId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> orderJson = jsonDecode(response.body);
        return orderJson.map((json) => Order.fromJson(json)).toList();
      } else {
        print('Error fetching orders: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Lỗi khi load danh sách đơn hàng');
      }
    } catch (e) {
      print('Exception occurred while fetching orders: $e');
      throw Exception('Lỗi khi load danh sách đơn hàng');
    }
  }
}
