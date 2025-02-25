import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'config/api_config.dart';
import 'config/auth_service.dart';

class MovieService {
  static Future<List<Movie>> fetchMovies() async {
    try {
      String? token = await AuthService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Token không hợp lệ hoặc chưa đăng nhập.");
      }

      final response = await http.get(
        Uri.parse(ApiConfig.moviesList),
        headers: {
          'Authorization': 'Bearer ${token.trim()}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return parseMovies(response.body);
      } else {
        throw Exception('Lỗi tải phim: ${response.body}');
      }
    } catch (e) {
      print("Lỗi khi gọi API movies: $e");
      throw Exception("Không thể lấy danh sách phim.");
    }
  }

  static List<Movie> parseMovies(String responseBody) {
    try {
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Lỗi parse JSON: $e");
    }
  }
}
