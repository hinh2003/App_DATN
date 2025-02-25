import 'package:flutter/material.dart';
import 'package:my_app/screens/auth/AuthGuard.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthGuard(
      child: Center(
        child: Text("Likes Screen", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
