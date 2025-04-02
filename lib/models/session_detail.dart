import 'student.dart';
import 'attendance_summary.dart';

class SessionDetail {
  final String className;
  final int sessionId;
  final AttendanceSummary attendance;
  final List<Student> attendedStudents;
  final List<Student> notAttendedStudents;

  SessionDetail({
    required this.className,
    required this.sessionId,
    required this.attendance,
    required this.attendedStudents,
    required this.notAttendedStudents,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      className: json['className'],
      sessionId: json['sessionInfo']['id'],
      attendance: AttendanceSummary.fromJson(json['attendance']),
      attendedStudents: (json['attendedStudents'] as List<dynamic>)
          .map((student) => Student.fromJson(student))
          .toList(),
      notAttendedStudents: (json['notAttendedStudents'] as List<dynamic>)
          .map((student) => Student.fromJson(student))
          .toList(),
    );
  }
}
