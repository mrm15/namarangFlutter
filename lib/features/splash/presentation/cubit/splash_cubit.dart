import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/core/utils/logger.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._secureStorage) : super(const SplashState());

  final SecureStorage _secureStorage;

  Future<void> initialize() async {
    final accessToken = await _secureStorage.getAccessToken();

    AppLogger.i('Splash check token => ${accessToken != null}');
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = accessToken != null && accessToken.isNotEmpty;

    emit(state.copyWith(isLoading: false, isLoggedIn: isLoggedIn));
  }
}
