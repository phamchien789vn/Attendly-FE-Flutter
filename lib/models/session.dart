class Session {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final String duration;
  final String? status;
  final String? remainingTime;
  final bool isActive;
  final String qrCode;
  final DateTime? createdAt;
  final int totalAttendance;

  Session({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.status,
    this.remainingTime,
    required this.isActive,
    required this.qrCode,
    this.createdAt,
    required this.totalAttendance,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration'] ?? '',
      status: json['status'],
      remainingTime: json['remainingTime'],
      isActive: json['isActive'] ?? false,
      qrCode: json['qrCode'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      totalAttendance: json['attendance']?['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      if (status != null) 'status': status,
      if (remainingTime != null) 'remainingTime': remainingTime,
      'isActive': isActive,
      'qrCode': qrCode,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'totalAttendance': totalAttendance,
    };
  }
}
