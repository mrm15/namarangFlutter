import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/dio_client.dart';
import 'package:namarang/core/storage/secure_storage.dart';

import 'package:namarang/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namarang/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:namarang/features/auth/domain/repositories/auth_repository.dart';
import 'package:namarang/features/auth/domain/usecases/login_usecase.dart';
import 'package:namarang/features/auth/domain/usecases/verify_otp_usecase.dart';

import 'package:namarang/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:namarang/features/splash/presentation/cubit/splash_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Dio
  locator.registerLazySingleton<Dio>(
    () => DioClient.create(locator<SecureStorage>()),
  );

  // Api Client
  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator<Dio>()));

  // Storage
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // DataSource
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<ApiClient>()),
  );

  // Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<AuthRemoteDataSource>(),
      locator<SecureStorage>(),
    ),
  );

  // UseCases
  locator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(locator<AuthRepository>()),
  );

  // Cubits
  locator.registerFactory<AuthCubit>(
    () => AuthCubit(locator<LoginUseCase>(), locator<VerifyOtpUseCase>()),
  );

  locator.registerFactory<SplashCubit>(
    () => SplashCubit(locator<SecureStorage>()),
  );
}
