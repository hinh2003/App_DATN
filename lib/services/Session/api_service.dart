import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String apiUrl = 'http://192.168.132.106:8000/api/login';

  static Future<void> login(String name, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } else {
      var errorData = jsonDecode(response.body);
      String errorMessage = errorData['message'] ?? 'Đăng nhập thất bại.';

      print("Lỗi: $errorMessage");
      throw Exception(errorMessage);
    }
  }
}
