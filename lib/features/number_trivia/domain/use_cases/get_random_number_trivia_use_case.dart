import 'package:dartz/dartz.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/use_cases/use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';

class GetRandomNumberTriviaUseCase implements IUseCase<NumberTrivia, NoParams> {
  final INumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
