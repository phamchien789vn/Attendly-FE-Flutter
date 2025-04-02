import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/teacher_screen.dart';
import 'screens/student_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Attendly',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/teacher': (context) => const TeacherScreen(),
          '/student': (context) => const StudentScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check auth status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Nếu không có token hoặc role, chuyển về màn hình đăng nhập
        if (auth.jwtPayload == null || auth.userRole == null) {
          return const LoginScreen();
        }

        // Kiểm tra role và chuyển đến màn hình tương ứng
        switch (auth.userRole) {
          case 'teacher':
            return const TeacherScreen();
          case 'student':
            return const StudentScreen();
          default:
            // Nếu role không hợp lệ, đăng xuất và chuyển về màn hình đăng nhập
            auth.logout();
            return const LoginScreen();
        }
      },
    );
  }
}
