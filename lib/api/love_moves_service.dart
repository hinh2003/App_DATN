import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/LoveMovies.dart';
import 'config/api_config.dart';
import 'config/auth_service.dart';

class LoveMoviesService {
  static Future<List<LoveMovies>> fetchMovies(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.listLoveMovies),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return parseMovies(response.body);
      } else if (response.statusCode == 401) {
        throw Exception(
          "Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.",
        );
      } else {
        throw Exception(
          "Lỗi tải phim: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("Lỗi khi gọi API movies: $e");
      throw Exception("Không thể lấy danh sách phim.");
    }
  }

  static List<LoveMovies> parseMovies(String responseBody) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(responseBody);
      final List<dynamic> jsonList = jsonMap['movies'] ?? [];

      return jsonList.map((json) => LoveMovies.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Lỗi parse JSON: $e");
    }
  }
}
