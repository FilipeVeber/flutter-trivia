import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/use_cases/use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';

class GetConcreteNumberTriviaUseCase implements IUseCase<NumberTrivia, Params> {
  final INumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
