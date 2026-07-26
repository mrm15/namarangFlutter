import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../api/api_client.dart';
import '../api/dio_client.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<Dio>(DioClient.create);

  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator<Dio>()));
}
