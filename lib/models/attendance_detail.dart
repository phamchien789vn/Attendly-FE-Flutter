class AttendanceDetail {
  final int studentId;
  final String studentName;
  final String studentEmail;
  final DateTime attendedAt;

  AttendanceDetail({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.attendedAt,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentEmail: json['studentEmail'],
      attendedAt: DateTime.parse(json['attendedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'attendedAt': attendedAt.toIso8601String(),
    };
  }
}
