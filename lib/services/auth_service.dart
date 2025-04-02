import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../models/jwt_payload.dart';
import '../utils/constants.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  Future<JwtPayload> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.auth}${ApiConstants.login}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<String>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          // Decode JWT token
          final token = apiResponse.data!;
          final parts = token.split('.');
          if (parts.length != 3) {
            throw Exception('Invalid token format');
          }

          final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );

          final jwtPayload = JwtPayload.fromJson(payload);
          await storage.write(key: _tokenKey, value: token);
          await storage.write(key: 'user_role', value: jwtPayload.role);

          return jwtPayload;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<JwtPayload> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.auth}${ApiConstants.register}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final apiResponse = ApiResponse<String>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          // Decode JWT token
          final token = apiResponse.data!;
          final parts = token.split('.');
          if (parts.length != 3) {
            throw Exception('Token không hợp lệ');
          }

          final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );

          final jwtPayload = JwtPayload.fromJson(payload);
          await storage.write(key: _tokenKey, value: token);
          await storage.write(key: 'user_role', value: jwtPayload.role);

          return jwtPayload;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Đăng ký thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<String> logout() async {
    try {
      final token = await storage.read(key: _tokenKey);
      if (token != null) {
        final response = await http.post(
          Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.auth}${ApiConstants.logout}',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final apiResponse = ApiResponse.fromJson(json.decode(response.body));
          if (apiResponse.isSuccess) {
            await storage.delete(key: _tokenKey);
            await storage.delete(key: 'user_role');
            return apiResponse.message;
          } else {
            throw Exception(apiResponse.message);
          }
        }
      }
      await storage.delete(key: _tokenKey);
      await storage.delete(key: 'user_role');
      return 'Đăng xuất thành công';
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  Future<String?> getUserRole() async {
    return await storage.read(key: 'user_role');
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }
}
