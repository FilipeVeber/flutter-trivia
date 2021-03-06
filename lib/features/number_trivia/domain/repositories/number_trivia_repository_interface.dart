import 'package:dartz/dartz.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';

abstract class INumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
