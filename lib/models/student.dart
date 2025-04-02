class Student {
  final int id;
  final String name;
  final String email;
  final DateTime? attendedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    this.attendedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      attendedAt: json['attendedAt'] != null
          ? DateTime.parse(json['attendedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (attendedAt != null) 'attendedAt': attendedAt!.toIso8601String(),
    };
  }
}
