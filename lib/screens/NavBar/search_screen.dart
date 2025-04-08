import 'package:flutter/material.dart';
import 'package:my_app/api/movie_service.dart';
import 'package:my_app/models/movie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movies = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await MovieService.searchMovies(query);
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      setState(() {
        _movies = [];
      });
      print('Lỗi: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for movies',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMovies(_searchController.text),
                ),
              ),
              onChanged: (query) => _searchMovies(query),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child:
                      _movies.isEmpty
                          ? const Center(child: Text("No movies found"))
                          : ListView.builder(
                            itemCount: _movies.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_movies[index].nameMovie),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
    );
  }
}
