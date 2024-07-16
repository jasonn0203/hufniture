import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/models/Auth/user_register.dart';

import 'package:hufniture/data/services/shared_preference_helper.dart';

class AuthService {
  Future<String?> registerUser(UserRegister user) async {
    final url = Uri.parse(Environment.registerUrl);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
    };
    final body = jsonEncode(user.toJson());

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'];
        return errorMessage;
      }
    } catch (e) {
      debugPrint('Lỗi khi đăng ký: $e');
      return 'Đã xảy ra lỗi khi đăng ký. Vui lòng thử lại.';
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse(Environment.loginUrl);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
    };
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        final user = responseBody['user'];

        // Lưu token và thông tin người dùng vào SharedPreferences
        await SharedPreferencesHelper.saveAuthToken(token);
        await SharedPreferencesHelper.saveUser(user);

        return null;
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'];
        return errorMessage;
      }
    } catch (e) {
      debugPrint('Lỗi khi đăng nhập: $e');
      return 'Đã xảy ra lỗi khi đăng nhập. Vui lòng thử lại.';
    }
  }
}
