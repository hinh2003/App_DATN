import 'package:flutter/material.dart';
import 'package:my_app/models/ChapMovies.dart';
import 'package:my_app/screens/ChapMovies/VideoChapScreen.dart';

class ChapterListScreen extends StatefulWidget {
  final int movieId;
  final List<Chapmovies> chapters;

  const ChapterListScreen({
    Key? key,
    required this.movieId,
    required this.chapters,
  }) : super(key: key);

  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  final GlobalKey<VideoPlayerScreenState> _videoPlayerKey =
      GlobalKey<VideoPlayerScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách tập")),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: VideoPlayerScreen(
              key: _videoPlayerKey,
              videoUrl: widget.chapters.first.linkChap,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.chapters.length,
              itemBuilder: (context, index) {
                final chapter = widget.chapters[index];
                return ListTile(
                  title: Text("Tập ${chapter.nameChap}"),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () {
                    _videoPlayerKey.currentState?.setVideoUrl(chapter.linkChap);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
