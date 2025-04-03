import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/jwt_payload.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  JwtPayload? _jwtPayload;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  JwtPayload? get jwtPayload => _jwtPayload;
  String? get userRole => _jwtPayload?.role;

  Future<void> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await _authService.getToken();
      if (token != null) {
        // Decode JWT token
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );
          _jwtPayload = JwtPayload.fromJson(payload);

          // Kiểm tra token hết hạn
          if (_jwtPayload!.exp <
              DateTime.now().millisecondsSinceEpoch ~/ 1000) {
            await logout();
          }
        }
      }
    } catch (e) {
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      _successMessage = null;
      notifyListeners();

      _jwtPayload = await _authService.login(email, password);
      _successMessage = 'Đăng nhập thành công';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    try {
      _isLoading = true;
      _error = null;
      _successMessage = null;
      notifyListeners();

      _jwtPayload = await _authService.register(name, email, password, role);
      _successMessage = 'Đăng ký thành công';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      _error = null;
      _successMessage = null;
      notifyListeners();

      await _authService.logout();
      _jwtPayload = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
