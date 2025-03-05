import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/api/config/auth_service.dart';
import 'package:my_app/api/love_moves_service.dart';
import 'package:my_app/models/LoveMovies.dart';
import 'package:my_app/screens/Movie/MovieDetailScreen.dart';
import 'package:my_app/screens/auth/AuthGuard.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  Future<List<LoveMovies>>? _futureMovies;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchMovies();
  }

  Future<void> _loadTokenAndFetchMovies() async {
    String? token = await AuthService.getToken();

    if (token != null && token.isNotEmpty) {
      setState(() {
        _futureMovies = LoveMoviesService.fetchMovies(token);
      });
    } else {
      setState(() {
        _futureMovies = Future.error(
          "Bạn chưa đăng nhập hoặc token không hợp lệ.",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(title: const Text("Phim Yêu Thích")),
        body: FutureBuilder<List<LoveMovies>>(
          future: _futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Lỗi: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Bạn chưa có phim yêu thích nào."),
              );
            }

            List<LoveMovies> movies = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: false,
                physics: const BouncingScrollPhysics(), // ✅ Cho phép cuộn
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl:
                                  movie.pic.isNotEmpty
                                      ? movie.pic
                                      : "assets/images/placeholder.png",
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.asset(
                                    "assets/images/placeholder.png",
                                    fit: BoxFit.cover,
                                  ),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie.nameMovie,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
