import 'package:dartz/dartz.dart';
import 'package:flutter_trivia/core/error/exceptions.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/network/network_info_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDataSource remoteDataSource;
  final INumberTriviaLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  NumberTriviaRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaModel>> _getTrivia(
      _ConcreteOrRandomChooser getTriviaMethod) async {
    if (await networkInfo.isConnected) {
      try {
        final trivia = await getTriviaMethod();

        localDataSource.cacheNumberTrivia(trivia);

        return Right(trivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final trivia = await localDataSource.getNumberTrivia();
        return Right(trivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
