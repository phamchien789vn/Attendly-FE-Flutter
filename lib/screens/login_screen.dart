import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Đăng nhập'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            // Kiểm tra và chuyển hướng nếu đã đăng nhập
            if (auth.jwtPayload != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (auth.userRole == 'teacher') {
                  Navigator.pushReplacementNamed(context, '/teacher');
                } else if (auth.userRole == 'student') {
                  Navigator.pushReplacementNamed(context, '/student');
                }
              });
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) {
                            return 'Vui lòng nhập email hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (auth.isLoading)
                        const CircularProgressIndicator()
                      else if (auth.error != null)
                        Text(
                          auth.error!,
                          style: const TextStyle(color: Colors.red),
                        )
                      else
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Đăng nhập'),
                        ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: const Text('Chưa có tài khoản? Đăng ký'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
