class ApiConfig {
  static const String urlImg = 'http://192.168.1.150:8000';
  static const String baseUrl = 'http://192.168.1.150:8000/api';

  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String moviesList = '$baseUrl/movies/list';
  static const String listBanner = '$baseUrl/banner';
  static const String listChapMovies = '$baseUrl/movies/chap/{id}';
}
