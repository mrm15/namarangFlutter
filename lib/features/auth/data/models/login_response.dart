class LoginResponse {
  final bool success;
  final bool status;
  final String message;

  const LoginResponse({
    required this.success,
    required this.status,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'status': status, 'message': message};
  }
}
