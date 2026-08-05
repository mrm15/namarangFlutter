import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:namarang/core/api/api_client.dart';
import 'package:namarang/core/api/dio_client.dart';
import 'package:namarang/core/storage/secure_storage.dart';
import 'package:namarang/core/session/session_controller.dart';

import 'package:namarang/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namarang/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:namarang/features/auth/domain/repositories/auth_repository.dart';
import 'package:namarang/features/auth/domain/usecases/login_usecase.dart';
import 'package:namarang/features/auth/domain/usecases/verify_otp_usecase.dart';

import 'package:namarang/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:namarang/features/work_status/data/datasources/work_status_remote_data_source.dart';
import 'package:namarang/features/work_status/data/repositories/work_status_repository_impl.dart';
import 'package:namarang/features/work_status/domain/repositories/work_status_repository.dart';
import 'package:namarang/features/work_status/domain/usecases/get_work_status_usecase.dart';
import 'package:namarang/features/work_status/domain/usecases/set_work_status_usecase.dart';
import 'package:namarang/features/work_status/presentation/cubit/work_status_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Storage
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());
  locator.registerLazySingleton<SessionController>(
    () => SessionController(locator<SecureStorage>()),
  );

  // Dio
  locator.registerLazySingleton<Dio>(
    () => DioClient.create(
      locator<SecureStorage>(),
      locator<SessionController>(),
    ),
  );

  // Api Client
  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator<Dio>()));

  // DataSource
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<ApiClient>()),
  );

  // Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<AuthRemoteDataSource>(),
      locator<SecureStorage>(),
      locator<SessionController>(),
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

  locator.registerLazySingleton<WorkStatusRemoteDataSource>(
    () => WorkStatusRemoteDataSourceImpl(locator<ApiClient>()),
  );
  locator.registerLazySingleton<WorkStatusRepository>(
    () => WorkStatusRepositoryImpl(locator<WorkStatusRemoteDataSource>()),
  );
  locator.registerLazySingleton<GetWorkStatusUseCase>(
    () => GetWorkStatusUseCase(locator<WorkStatusRepository>()),
  );
  locator.registerLazySingleton<SetWorkStatusUseCase>(
    () => SetWorkStatusUseCase(locator<WorkStatusRepository>()),
  );
  locator.registerFactory<WorkStatusCubit>(
    () => WorkStatusCubit(
      locator<GetWorkStatusUseCase>(),
      locator<SetWorkStatusUseCase>(),
    ),
  );
}
