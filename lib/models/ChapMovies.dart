class Chapmovies {
  final int id;
  final int nameChap;
  final String linkChap;
  final int movieId;

  Chapmovies({
    required this.id,
    required this.nameChap,
    required this.linkChap,
    required this.movieId,
  });

  factory Chapmovies.fromJson(Map<String, dynamic> json) {
    return Chapmovies(
      id: json['id'],
      nameChap: json['name_chap'],
      linkChap: json['link_chap'],
      movieId: json['movie_id'],
    );
  }

  // Chuyển đổi danh sách JSON thành danh sách đối tượng Chapmovies
  static List<Chapmovies> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Chapmovies.fromJson(json)).toList();
  }
}
