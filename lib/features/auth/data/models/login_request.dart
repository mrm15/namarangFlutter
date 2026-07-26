class LoginRequest {
  final String phoneNumber;
  final bool secretMode;

  const LoginRequest({required this.phoneNumber, this.secretMode = false});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'secretMode': secretMode};
  }
}
