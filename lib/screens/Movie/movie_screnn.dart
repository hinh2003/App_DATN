import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/services/movie_service.dart';
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
    fetchMovies();
  }

  void fetchMovies() {
    setState(() {
      futureMovies = MovieService.fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách phim")),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lỗi: ${snapshot.error}"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchMovies,
                    child: Text("Thử lại"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có dữ liệu"));
          } else {
            List<Movie> movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final imageUrl = movie.pic.isNotEmpty ? movie.pic : "";
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
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child:
                            imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder:
                                      (context, url) =>
                                          CircularProgressIndicator(),
                                  errorWidget:
                                      (context, url, error) => Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.cover,
                                      ),
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  "assets/images/placeholder.png",
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    title: Text(
                      movie.nameMovie,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Tập: ${movie.episodes}"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
