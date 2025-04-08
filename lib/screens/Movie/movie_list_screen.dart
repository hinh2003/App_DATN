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
  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      List<Movie> newMovies = await MovieService.fetchMovies(page: currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          hasMore = false; // Không còn phim để tải
        } else {
          movies.addAll(newMovies);
          currentPage++;
        }
      });
    } catch (e) {
      print("Lỗi tải phim: $e");
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            movies.clear();
            currentPage = 1;
            hasMore = true;
          });
          await fetchMovies();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MovieBanner(),
              movies.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      MovieList(movies: movies),
                      if (hasMore)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed:
                                isLoadingMore
                                    ? null
                                    : () => fetchMovies(isLoadMore: true),
                            child:
                                isLoadingMore
                                    ? CircularProgressIndicator()
                                    : Text("Xem thêm"),
                          ),
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
