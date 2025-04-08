import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/api/config/api_config.dart';
import 'package:my_app/models/ChapMovies.dart';

class ChapMoviesService {
  static Future<List<Chapmovies>> fetchMovies(int id) async {
    try {
      String url = ApiConfig.listChapMovies.replaceFirst('{id}', id.toString());

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> chapMoviesList = jsonData['chap_movies'];

        return chapMoviesList.map((item) => Chapmovies.fromJson(item)).toList();
      } else {
        throw Exception('Lỗi tải phim: ${response.body}');
      }
    } catch (e) {
      print("Lỗi khi gọi API movies: $e");
      throw Exception("Không thể lấy danh sách phim.");
    }
  }
}
