import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieService {
  static const String apiUrl = 'http://192.168.132.106:8000/api/movies/list';

  static Future<List<Movie>> fetchMovies() async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token không hợp lệ hoặc chưa đăng nhập.");
    }

    print("Token: $token");

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${token.trim()}',
        'Accept': 'application/json',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies. Error: ${response.body}');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
