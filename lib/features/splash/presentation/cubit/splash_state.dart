import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final bool isLoggedIn;

  const SplashState({this.isLoading = true, this.isLoggedIn = false});

  SplashState copyWith({bool? isLoading, bool? isLoggedIn}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoggedIn];
}
