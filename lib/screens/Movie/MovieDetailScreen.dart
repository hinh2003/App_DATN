import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_app/api/chap_movies_servive.dart';
import 'package:my_app/models/ChapMovies.dart';
import 'package:my_app/screens/ChapMovies/ChapterListScreen.dart';
import '/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;
  List<Chapmovies> chapters = [];

  MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  String getCountryName(int countryId) {
    switch (countryId) {
      case 2:
        return "Nhật Bản";
      case 3:
        return "Trung Quốc";
      default:
        return "Không xác định";
    }
  }

  String getStatusName(int statusId) {
    switch (statusId) {
      case 2:
        return "Hoàn thành";
      case 3:
        return "Tiếp tục";
      default:
        return "Không xác định";
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = movie is Movie ? movie.pic : movie.pic;
    String movieName = movie is Movie ? movie.nameMovie : movie.nameMovie;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.nameMovie,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: 200,
                  height: 300,
                  imageUrl:
                      movie.pic.isNotEmpty
                          ? movie.pic
                          : "https://via.placeholder.com/200x300",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) => Icon(Icons.error, size: 50),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.nameMovie,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Số tập: ${movie.episodes}", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                "Trạng thái: ${getStatusName(movie.statusId)}",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                "Quốc gia: ${getCountryName(movie.countryId)}",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              Text(
                "Thể loại: ${movie.categories?.map((category) => category.nameCategory).join(', ')}",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Trailer",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      final response = await ChapMoviesService.fetchMovies(
                        movie.id,
                      );
                      if (response != null) {
                        chapters = response;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChapterListScreen(
                                  movieId: movie.id,
                                  chapters: chapters,
                                ),
                          ),
                        );
                      }
                    },
                    child: Text("Xem", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
