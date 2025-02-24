import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String apiUrl = 'http://192.168.1.150:8000/api/login';

  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      print("Đăng nhập thành công, token đã được lưu.");
    } else {
      var errorData = json.decode(response.body);
      String errorMessage =
          errorData['message'] ?? 'Đăng nhập thất bại. Vui lòng thử lại.';
      throw Exception(errorMessage);
    }
  }

  // Lấy token đã lưu
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<dynamic>> fetchMovies() async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('Token không hợp lệ');
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.150:8000/api/movies/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
