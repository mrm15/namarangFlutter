import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:namarang/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namarang/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:namarang/features/auth/domain/repositories/auth_repository.dart';
import 'package:namarang/features/auth/domain/usecases/login_usecase.dart';
import 'package:namarang/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:namarang/features/splash/presentation/cubit/splash_cubit.dart';

import '../api/api_client.dart';
import '../api/dio_client.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<Dio>(DioClient.create);

  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator<Dio>()));
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<ApiClient>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<AuthRemoteDataSource>()),
  );

  locator.registerLazySingleton(() => LoginUseCase(locator<AuthRepository>()));
  locator.registerFactory<AuthCubit>(() => AuthCubit(locator<LoginUseCase>()));
  locator.registerFactory<SplashCubit>(() => SplashCubit());
}
