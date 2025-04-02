import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/classroom.dart';
import '../models/session.dart';
import '../models/student.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import 'auth_service.dart';
import '../models/session_detail.dart';

class ClassroomService {
  final AuthService _authService = AuthService();

  Future<List<Classroom>> getTeacherClassrooms() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final classesInfo = apiResponse.data!['classesInfo'] as List<dynamic>;
          return classesInfo.map((json) => Classroom.fromJson(json)).toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể lấy danh sách lớp học');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<Classroom> createClassroom(String name) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 201) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          return Classroom.fromJson(apiResponse.data!);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể tạo lớp học');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // Lấy danh sách học sinh trong lớp
  Future<List<Student>> getClassroomStudents(int classroomId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}/$classroomId/students',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final students = apiResponse.data!['students'] as List<dynamic>;
          return students.map((json) => Student.fromJson(json)).toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể lấy danh sách học sinh');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // Tạo buổi học mới
  Future<Session> createSession(int classroomId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}/$classroomId/sessions',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        json.decode(response.body),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Session.fromJson(apiResponse.data!);
      } else {
        throw Exception(apiResponse.message ?? 'Không thể tạo buổi học');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Lỗi định dạng dữ liệu');
      }
      throw Exception(e.toString());
    }
  }

  // Lấy danh sách buổi học của lớp
  Future<List<Session>> getClassroomSessions(int classroomId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}/$classroomId/sessions',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final sessions = apiResponse.data!['sessions'] as List<dynamic>;
          return sessions.map((json) => Session.fromJson(json)).toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể lấy danh sách buổi học');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // Lấy danh sách điểm danh của một buổi học
  Future<List<Student>> getSessionAttendance(
    int classroomId,
    int sessionId,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}/$classroomId/sessions/$sessionId/attendance',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          final students = apiResponse.data!['students'] as List<dynamic>;
          return students.map((json) => Student.fromJson(json)).toList();
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể lấy danh sách điểm danh');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<SessionDetail> getSessionDetail(int classroomId, int sessionId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Không tìm thấy token xác thực');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.version1}${ApiConstants.classes}/$classroomId/sessions/$sessionId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          json.decode(response.body),
        );

        if (apiResponse.isSuccess && apiResponse.data != null) {
          return SessionDetail.fromJson(apiResponse.data!);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Không thể lấy chi tiết điểm danh');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
