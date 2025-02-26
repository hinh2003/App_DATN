import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/banner.dart';
import 'config/api_config.dart';

class BannerService {
  static Future<List<Banners>> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.listBanner),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        return parseBanners(response.body);
      } else {
        throw Exception('Lỗi tải banner: ${response.body}');
      }
    } catch (e) {
      print("Lỗi khi gọi API banners: $e");
      throw Exception("Không thể lấy danh sách banners.");
    }
  }

  static List<Banners> parseBanners(String responseBody) {
    try {
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((json) => Banners.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Lỗi parse JSON: $e");
    }
  }
}
