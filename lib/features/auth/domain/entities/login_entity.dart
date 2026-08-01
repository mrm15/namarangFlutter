import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  const LoginEntity({required this.success, required this.message});

  final bool success;
  final String message;

  @override
  List<Object?> get props => [success, message];
}
