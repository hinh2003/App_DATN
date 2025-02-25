import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/models/movie.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(child: Text("Không có dữ liệu phim."));
    }

    return ListView.builder(
      physics:
          NeverScrollableScrollPhysics(), // ✅ Không cuộn riêng, cuộn theo `SingleChildScrollView`
      shrinkWrap: true, // ✅ Cho phép nằm trong `Column`
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                imageUrl:
                    movie.pic.isNotEmpty
                        ? movie.pic
                        : "https://via.placeholder.com/60",
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) =>
                        Image.asset("assets/images/placeholder.png"),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              movie.nameMovie,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Tập: ${movie.episodes}"),
            onTap: () {
              // TODO: Điều hướng đến màn hình chi tiết phim
            },
          ),
        );
      },
    );
  }
}
