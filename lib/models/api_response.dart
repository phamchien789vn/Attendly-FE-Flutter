class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  ApiResponse({required this.isSuccess, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'isSuccess': isSuccess, 'message': message, 'data': data};
  }
}
