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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        print("Token được lưu: $token");
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
}
