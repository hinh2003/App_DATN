import 'package:my_app/api/config/api_config.dart';

class Banners {
  final String title;
  final String image;

  Banners({required this.title, required this.image});

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      title: json['title'] ?? 0,
      image: Uri.parse(ApiConfig.urlImg + "/${json['image'] ?? ''}").toString(),
    );
  }
}
