import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static Future<void> login(String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'password': password}),
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token']['plainTextToken'];
        String username = data['user']['name'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);

        print("Token được lưu: $token");
        print("Ten được lưu: $username");
      } else {
        _handleError(response);
      }
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
      throw Exception("Có lỗi xảy ra khi đăng nhập.");
    }
  }

  static void _handleError(http.Response response) {
    var errorData = jsonDecode(response.body);
    String errorMessage =
        errorData['message'] is String
            ? errorData['message']
            : 'Có lỗi xảy ra khi đăng nhập.';
    print("Lỗi đăng nhập: $errorMessage");
    throw Exception(errorMessage);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("Không tìm thấy token");
        return;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.logout),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('username');
        print("Ban da dang xuat thanh cong");
      } else {
        print("Lỗi khi đăng xuất: ${response.body}");
      }
    } catch (e) {
      print("Lỗi: $e");
    }
  }
}
