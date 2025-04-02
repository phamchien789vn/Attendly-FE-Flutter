class AttendanceSummary {
  final int total;
  final int attended;
  final int notAttended;
  final String attendanceRate;

  AttendanceSummary({
    required this.total,
    required this.attended,
    required this.notAttended,
    required this.attendanceRate,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      total: json['total'],
      attended: json['attended'],
      notAttended: json['notAttended'],
      attendanceRate: json['attendanceRate'],
    );
  }
}
