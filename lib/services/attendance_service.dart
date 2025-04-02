import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'auth_service.dart';

class AttendanceService {
  final AuthService _authService = AuthService();

  Future<void> markAttendance(String qrCode) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}${ApiConstants.attendance}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'qrCode': qrCode,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        if (!responseData['isSuccess']) {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception(responseData['message'] ?? 'Điểm danh thất bại');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
