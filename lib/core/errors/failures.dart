import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('اتصال اینترنت را بررسی کنید.');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
    : super('نشست شما منقضی شده است. دوباره وارد شوید.');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'خطایی در ارتباط با سرور رخ داد.']);
}

class InvalidResponseFailure extends Failure {
  const InvalidResponseFailure() : super('پاسخ دریافتی از سرور معتبر نیست.');
}
