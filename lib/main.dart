import 'package:flutter/material.dart';
import 'screens/signin_screnn.dart';
import 'screens/Movie/movie_screnn.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Đường dẫn mặc định
      routes: {
        '/': (context) => SignInPage2(), // Màn hình đăng nhập
        '/movie_list': (context) => MovieListScreen(), // Màn hình Home
        '/home': (context) => MainScreen(), // Màn hình chính với Bottom Nav
      },
    );
  }
}
