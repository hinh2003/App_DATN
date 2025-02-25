import 'package:flutter/material.dart';
import 'screens/signin_screnn.dart';
import 'screens/signup_screen.dart';
import 'screens/Movie/movie_list_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // Đường dẫn mặc định
      routes: {
        '/signin': (context) => SignInPage2(), // Màn hình đăng nhập
        '/signup': (context) => SignUpPage(),
        '/movie_list': (context) => MovieListScreen(), // Màn hình Home
        '/home': (context) => MainScreen(), // Màn hình chính với Bottom Nav
      },
    );
  }
}
