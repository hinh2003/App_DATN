import 'package:my_app/api/config/api_config.dart';
import 'package:my_app/models/Category.dart';
import 'package:my_app/models/Country.dart';
import 'package:my_app/models/Status.dart';

class Movie {
  final int id;
  final String nameMovie;
  final String pic;
  final int episodes;
  final String description;
  final int countryId;
  final int statusId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Country? country;
  final Status? status;
  final List<Category>? categories;

  Movie({
    required this.id,
    required this.nameMovie,
    required this.pic,
    required this.episodes,
    required this.description,
    required this.countryId,
    required this.statusId,
    this.createdAt,
    this.updatedAt,
    this.country,
    this.status,
    this.categories,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      nameMovie: json['name_movie'] ?? 'Không có tên',
      pic:
          Uri.parse(
            ApiConfig.urlImg + "/frontend/${json['pic'] ?? ''}",
          ).toString(),
      episodes: json['episodes'] ?? 0,
      description: json['description'] ?? 'Không có mô tả',
      countryId: json['country_id'] ?? 0,
      statusId: json['status_id'] ?? 0,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      categories:
          json['categories'] != null
              ? (json['categories'] as List)
                  .map((category) => Category.fromJson(category))
                  .toList()
              : [],
    );
  }
}
