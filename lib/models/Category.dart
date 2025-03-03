class Category {
  final int id;
  final String nameCategory;
  final String description;

  Category({
    required this.id,
    required this.nameCategory,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameCategory: json['name_category'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $nameCategory, desc: $description)';
  }
}
