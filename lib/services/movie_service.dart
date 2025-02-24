import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences nếu bạn dùng nó

class MovieService {
  static const String apiUrl = 'http://192.168.1.150:8000/api/movies/list';

  static Future<List<Movie>> fetchMovies() async {
    // Lấy token từ SharedPreferences
    String? token = await _getToken();

    if (token == null) {
      throw Exception("Token không hợp lệ");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header Authorization
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Hàm lấy token từ SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Giả sử token được lưu với key là 'token'
  }
}
