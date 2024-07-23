import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hufniture/configs/environment.dart';
import 'package:hufniture/data/models/Auth/user_register.dart';

import 'package:hufniture/data/services/shared_preference_helper.dart';

enum Gender { Male, Female }

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

  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      return null;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse(Environment.getUserInfo(userId)),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint(
            'Lỗi khi lấy thông tin người dùng: ${response.reasonPhrase} - $userId');
        return null;
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi API lấy thông tin người dùng: $e');
      return null;
    }
  }

  Future<String?> updateUserAddress(String userId, String address) async {
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      return 'Không tìm thấy token xác thực.';
    }

    final url = Uri.parse(Environment.updateUserInfo(userId));
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'address': address,
    });

    try {
      final response = await http.put(
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
      debugPrint('Lỗi khi cập nhật địa chỉ: $e');
      return 'Đã xảy ra lỗi khi cập nhật địa chỉ. Vui lòng thử lại.';
    }
  }

  Future<bool> updateUser(
    user, {
    required String userId,
    required String fullName,
    required String phoneNumber,
    DateTime? birthDate,
    String? gender,
  }) async {
    final url = Uri.parse(Environment.updateUserInfo(userId));
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      print('Không tìm thấy token xác thực.');
    }

    // Chuyển đổi giá trị gender từ String thành enum
    Gender? genderEnum;
    if (gender == 'Nam') {
      genderEnum = Gender.Male;
    } else if (gender == 'Nữ') {
      genderEnum = Gender.Female;
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'FullName': fullName,
        'PhoneNumber': phoneNumber,
        'BirthDate': birthDate?.toIso8601String(),
        'Gender':
            genderEnum?.toString().split('.').last, // Chuyển enum thành String
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update user: ${response.body}');
      return false;
    }
  }

  Future<bool> changePassword(
    String userId, {
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực.');
    }

    final response = await http.post(
      Uri.parse(Environment.changePasswordUrl(userId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      try {
        final responseBody = jsonDecode(response.body);
        final message =
            responseBody is Map && responseBody.containsKey('message')
                ? responseBody['message']
                : 'Đổi mật khẩu thất bại';
        throw Exception(message);
      } catch (e) {
        // Nếu có lỗi khi phân tích JSON, hiển thị thông báo lỗi chung
        throw Exception('Đổi mật khẩu thất bại.');
      }
    }
  }

  // Check email
  Future<bool> checkEmailExists(String email) async {
    final url = Uri.parse(Environment.checkEmailUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'Success';
    }
    return false;
  }

  // Forgot pw
  Future<bool> resetPassword(
      String email, String newPassword, String confirmNewPassword) async {
    final url = Uri.parse(Environment.forgotPasswordUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'Success';
    }
    return false;
  }
}
