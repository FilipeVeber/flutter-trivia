import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/error/exceptions.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/network/network_info_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_trivia/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:mocktail/mocktail.dart';

class RemoteDataSourceMock extends Mock
    implements INumberTriviaRemoteDataSource {}

class LocalDataSourceMock extends Mock implements INumberTriviaLocalDataSource {
}

class NetworkInfoMock extends Mock implements INetworkInfo {}

main() {
  late RemoteDataSourceMock remoteDataSourceMock;
  late LocalDataSourceMock localDataSourceMock;
  late NetworkInfoMock networkInfoMock;
  late NumberTriviaRepository repository;

  setUp(() {
    remoteDataSourceMock = RemoteDataSourceMock();
    localDataSourceMock = LocalDataSourceMock();
    networkInfoMock = NetworkInfoMock();
    repository = NumberTriviaRepository(
        remoteDataSource: remoteDataSourceMock,
        localDataSource: localDataSourceMock,
        networkInfo: networkInfoMock);
  });

  group("getConcreteNumberTrivia", () {
    const number = 1;
    const triviaModel = NumberTriviaModel(text: "Test", number: number);
    const trivia = triviaModel;

    test("Should check if the device is online", () async {
      when(() => networkInfoMock.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(number);

      verify(() => networkInfoMock.isConnected).called(1);
    });

    void runOnlineTests(Function body) {
      group("device is online", () {
        setUp(() {
          when(() => networkInfoMock.isConnected).thenAnswer((_) async => true);
        });
      });

      body();
    }

    void runOfflineTests(Function body) {
      group("device is offline", () {
        setUp(() {
          when(() => networkInfoMock.isConnected)
              .thenAnswer((_) async => false);
        });
      });

      body();
    }

    runOnlineTests(() {
      test(
          "Should return remote data when the call to remote data source is successful",
          () async {
        when(() => remoteDataSourceMock.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => triviaModel);

        final result = await repository.getConcreteNumberTrivia(number);

        verify(() => remoteDataSourceMock.getConcreteNumberTrivia(number));
        expect(result, const Right(trivia));
      });

      test(
          "Should cache the data locally when the call to remote data source is successful",
          () async {
        when(() => remoteDataSourceMock.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => triviaModel);

        await repository.getConcreteNumberTrivia(number);

        verify(() => remoteDataSourceMock.getConcreteNumberTrivia(number));
        verify(() => localDataSourceMock.cacheNumberTrivia(triviaModel));
      });

      test(
          "Should return a server failure when the call to remote data source is unsuccessful",
          () async {
        when(() => remoteDataSourceMock.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(number);

        verify(() => remoteDataSourceMock.getConcreteNumberTrivia(number));
        verifyZeroInteractions(localDataSourceMock);
        expect(result, Left(ServerFailure()));
      });
    });

    runOfflineTests(() {
      setUp(() {
        when(() => networkInfoMock.isConnected).thenAnswer((_) async => false);
      });

      test("Should return last locally data when the cache data is present",
          () async {
        when(() => localDataSourceMock.getNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repository.getConcreteNumberTrivia(number);

        verifyZeroInteractions(remoteDataSourceMock);
        verify(() => localDataSourceMock.getNumberTrivia());
        expect(result, const Right(trivia));
      });

      test("Should return CacheFailure when there is no cached data present",
          () async {
        when(() => localDataSourceMock.getNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(number);

        verifyZeroInteractions(remoteDataSourceMock);
        verify(() => localDataSourceMock.getNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group("getRandomNumberTrivia", () {
    const triviaModel = NumberTriviaModel(text: "Test", number: 123);
    const trivia = triviaModel;

    test("Should check if the device is online", () async {
      when(() => networkInfoMock.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(() => networkInfoMock.isConnected);
    });

    void runOnlineTests(Function body) {
      group("device is online", () {
        setUp(() {
          when(() => networkInfoMock.isConnected).thenAnswer((_) async => true);
        });
      });

      body();
    }

    void runOfflineTests(Function body) {
      group("device is offline", () {
        setUp(() {
          when(() => networkInfoMock.isConnected)
              .thenAnswer((_) async => false);
        });
      });

      body();
    }

    runOnlineTests(() {
      test(
          "Should return remote data when the call to remote data source is successful",
          () async {
        when(() => remoteDataSourceMock.getRandomNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(() => remoteDataSourceMock.getRandomNumberTrivia());
        expect(result, const Right(trivia));
      });

      test(
          "Should cache the data locally when the call to remote data source is successful",
          () async {
        when(() => remoteDataSourceMock.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => triviaModel);

        await repository.getRandomNumberTrivia();

        verify(() => remoteDataSourceMock.getRandomNumberTrivia());
        verify(() => localDataSourceMock.cacheNumberTrivia(triviaModel));
      });

      test(
          "Should return a server failure when the call to remote data source is unsuccessful",
          () async {
        when(() => remoteDataSourceMock.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(() => remoteDataSourceMock.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSourceMock);
        expect(result, Left(ServerFailure()));
      });
    });

    runOfflineTests(() {
      setUp(() {
        when(() => networkInfoMock.isConnected).thenAnswer((_) async => false);
      });

      test("Should return last locally data when the cache data is present",
          () async {
        when(() => localDataSourceMock.getNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSourceMock);
        verify(() => localDataSourceMock.getNumberTrivia());
        expect(result, Right(trivia));
      });

      test("Should return CacheFailure when there is no cached data present",
          () async {
        when(() => localDataSourceMock.getNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSourceMock);
        verify(() => localDataSourceMock.getNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
