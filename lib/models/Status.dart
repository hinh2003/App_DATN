class Status {
  final int id;
  final String nameStatus;
  final String description;

  Status({
    required this.id,
    required this.nameStatus,
    required this.description,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] ?? 0,
      nameStatus: json['name_satus'] ?? 'Không có trạng thái',
      description: json['description'] ?? 'Không có mô tả',
    );
  }
}
