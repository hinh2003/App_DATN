import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/api/Session/Session_service.dart';

class SignInPage2 extends StatelessWidget {
  const SignInPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child:
            isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [_Logo(), _FormContent()],
                )
                : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                      Expanded(child: _Logo()),
                      Expanded(child: Center(child: _FormContent())),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/placeholder.png',
          width: isSmallScreen ? 300 : 400,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to AnimeVietSub!",
            textAlign: TextAlign.center,
            style:
                isSmallScreen
                    ? Theme.of(context).textTheme.headlineMedium
                    : Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  String? responseMessage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String name = _usernameController.text;
    String password = _passwordController.text;
    try {
      await ApiService.login(name, password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print("Lỗi đăng nhập: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đăng nhập thất bại: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ô nhập Email
            TextFormField(
              controller:
                  _usernameController, // Đổi thành controller cho tên đăng nhập
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên đăng nhập';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                hintText: 'Nhập tên đăng nhập của bạn',
                prefixIcon: Icon(
                  Icons.person_outline,
                ), // Thay icon thành người dùng
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            // Ô nhập Mật khẩu
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),

            // Checkbox Remember Me
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Ghi nhớ đăng nhập'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),

            // Nút Đăng nhập
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _login();
                  }
                },
              ),
            ),
            _gap(),

            // Nút Đăng ký
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text(
                "Bạn chưa có tài khoản? Đăng ký ngay",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
