import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_trivia/core/network/network_info_interface.dart';
import 'package:flutter_trivia/core/utils/input_converter.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  /// Features - Number Trivia
  // Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
        concreteUseCase: serviceLocator(),
        randomUseCase: serviceLocator(),
        inputConverter: serviceLocator(),
      ));

  // Use cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTriviaUseCase(serviceLocator()));

  // Repositories
  serviceLocator.registerLazySingleton<INumberTriviaRepository>(
      () => NumberTriviaRepository(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data sources
  serviceLocator.registerLazySingleton<INumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSource(httpClient: serviceLocator()));

  serviceLocator.registerLazySingleton<INumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSource(sharedPreferences: serviceLocator()));

  // Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<INetworkInfo>(() => NetworkInfo(serviceLocator()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
