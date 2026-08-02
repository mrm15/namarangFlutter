import 'package:equatable/equatable.dart';

class VerifyOtpRequest extends Equatable {
  const VerifyOtpRequest({
    required this.phoneNumber,
    required this.loginCode,
    this.secretMode = false,
  });

  final String phoneNumber;
  final String loginCode;
  final bool secretMode;

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'loginCode': loginCode,
      'secretMode': secretMode,
    };
  }

  @override
  List<Object?> get props => [phoneNumber, loginCode, secretMode];
}
