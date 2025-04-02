class JwtPayload {
  final int id;
  final String role;
  final int iat;
  final int exp;

  JwtPayload({
    required this.id,
    required this.role,
    required this.iat,
    required this.exp,
  });

  factory JwtPayload.fromJson(Map<String, dynamic> json) {
    return JwtPayload(
      id: json['id'],
      role: json['role'],
      iat: json['iat'],
      exp: json['exp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'role': role, 'iat': iat, 'exp': exp};
  }
}
