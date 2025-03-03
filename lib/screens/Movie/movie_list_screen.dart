import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/api/movie_service.dart';
import 'movie_detail_screen.dart';
import 'MovieBanner.dart';
import '/models/movie.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    try {
      return await MovieService.fetchMovies();
    } catch (e) {
      throw Exception("Không thể tải phim. Vui lòng kiểm tra kết nối mạng.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureMovies = fetchMovies();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MovieBanner(),
              FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Lỗi: ${snapshot.error}"));
                  } else {
                    return MovieList(movies: snapshot.data ?? []);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
