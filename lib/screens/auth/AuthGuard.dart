import 'package:flutter/material.dart';
import 'package:my_app/api/Session/Session_service.dart';
import 'package:my_app/screens/signin_screnn.dart';
import 'package:my_app/screens/signup_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child; // Widget con (màn hình bên trong)

  const AuthGuard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ApiService.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isLoggedIn = snapshot.data ?? false;

        if (!isLoggedIn) {
          return _buildLoginPrompt(context);
        }

        return child;
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bạn cần đăng nhập để sử dụng tính năng này",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage2()),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text("Đăng nhập ngay"),
          ),
        ],
      ),
    );
  }
}
