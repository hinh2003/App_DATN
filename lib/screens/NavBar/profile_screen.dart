import 'package:flutter/material.dart';
import 'package:my_app/api/Session/Session_service.dart';

import 'package:flutter/material.dart';
import 'package:my_app/screens/signin_screnn.dart';
import 'package:my_app/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/api/Session/Session_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<bool> _isLoggedIn;
  late Future<String> _username;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = ApiService.isLoggedIn();
    _username = _loadUsername();
  }

  Future<void> _logout() async {
    ApiService.logout();
    setState(() {
      _isLoggedIn = Future.value(false);
      _username = Future.value("Người dùng");
    });
  }

  Future<String> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? "Bạn cần đăng nhập";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<bool>(
                future: _isLoggedIn,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  bool isLoggedIn = snapshot.data ?? false;

                  return Column(
                    children: [
                      FutureBuilder<String>(
                        future: _username,
                        builder: (context, snapshot) {
                          String username =
                              snapshot.data ?? "Bạn cần đăng nhập";
                          return Text(
                            "Xin chào, $username!",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!isLoggedIn) _buildAuthButtons(),
                      if (isLoggedIn) _buildLogoutButton(),
                      const SizedBox(height: 16),
                      Expanded(child: _buildMenuList(_isLoggedIn)),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage2()),
            );
          },
          icon: const Icon(Icons.login),
          label: const Text("Đăng nhập"),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          icon: const Icon(Icons.app_registration),
          label: const Text("Đăng ký"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout),
      label: const Text("Đăng xuất"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }

  Widget _buildMenuList(Future<bool> isLoggedInFuture) {
    return FutureBuilder<bool>(
      future: isLoggedInFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !(snapshot.data ?? false)) {
          return const SizedBox();
        }
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            _ProfileMenuItem(icon: Icons.bookmark, title: "Phim đã lưu"),
            _ProfileMenuItem(icon: Icons.history, title: "Phim đã xem"),
            _ProfileMenuItem(icon: Icons.info, title: "Thông tin phiên bản"),
          ],
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileMenuItem({Key? key, required this.icon, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        // Xử lý khi bấm vào từng mục
      },
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
