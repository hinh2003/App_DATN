class Country {
  final int id;
  final String nameCountry;
  final String description;

  Country({
    required this.id,
    required this.nameCountry,
    required this.description,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      nameCountry: json['name_country'] ?? 'Không có tên',
      description: json['description'] ?? 'Không có mô tả',
    );
  }
}
