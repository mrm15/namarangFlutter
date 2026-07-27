import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String phoneNumber;
  final bool secretMode;

  const LoginRequest({required this.phoneNumber, this.secretMode = false});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'secretMode': secretMode};
  }

  @override
  List<Object?> get props => [phoneNumber, secretMode];
}
