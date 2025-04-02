class SessionStatistics {
  final int totalSessions;
  final int activeSessions;
  final int upcomingSessions;
  final int inProgressSessions;
  final int endedSessions;

  SessionStatistics({
    required this.totalSessions,
    required this.activeSessions,
    required this.upcomingSessions,
    required this.inProgressSessions,
    required this.endedSessions,
  });

  factory SessionStatistics.fromJson(Map<String, dynamic> json) {
    return SessionStatistics(
      totalSessions: json['totalSessions'],
      activeSessions: json['activeSessions'],
      upcomingSessions: json['upcomingSessions'],
      inProgressSessions: json['inProgressSessions'],
      endedSessions: json['endedSessions'],
    );
  }
}
