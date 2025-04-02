class Classroom {
  final int id;
  final String name;
  final int totalStudents;

  Classroom({
    required this.id,
    required this.name,
    required this.totalStudents,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      totalStudents: json['totalStudents'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'totalStudents': totalStudents};
  }
}
