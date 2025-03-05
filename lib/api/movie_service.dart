import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'config/api_config.dart';
import 'config/auth_service.dart';

class MovieService {
  static Future<List<Movie>> fetchMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.moviesList}?page=$page"),
        headers: {'Accept': 'application/json'},
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

  static Future<List<Movie>> searchMovies(String name) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.searchMovies}/$name"),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return parsefindMovies(response.body);
        } else {
          throw Exception('Không có dữ liệu phim.');
        }
      } else {
        throw Exception(
          'Lỗi tải phim: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("Lỗi khi gọi API movies: $e");
      throw Exception("Không thể lấy danh sách phim. Vui lòng thử lại sau.");
    }
  }

  static List<Movie> parsefindMovies(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(responseBody);

      final List<dynamic> jsonList = jsonMap['movies'] ?? [];

      return jsonList.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Lỗi parse JSON: $e");
    }
  }

  static List<Movie> parseMovies(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(responseBody);

      final List<dynamic> jsonList = jsonMap['movies']?['data'] ?? [];

      return jsonList.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Lỗi parse JSON: $e");
    }
  }
}
