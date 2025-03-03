import 'package:flutter/material.dart';
import 'package:my_app/models/ChapMovies.dart';

class ChapterListScreen extends StatelessWidget {
  final int movieId;
  final List<Chapmovies> chapters;

  const ChapterListScreen({
    Key? key,
    required this.movieId,
    required this.chapters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách tập")),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return ListTile(
            title: Text("Tập ${chapter.nameChap}"),
            trailing: Icon(Icons.play_arrow),
            onTap: () {
              print("Mở link: ${chapter.linkChap}");
            },
          );
        },
      ),
    );
  }
}
