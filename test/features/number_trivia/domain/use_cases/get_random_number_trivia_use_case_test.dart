import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/use_cases/use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:mocktail/mocktail.dart';

class NumberTriviaRepositoryMock extends Mock
    implements INumberTriviaRepository {}

main() {
  final numberTriviaRepository = NumberTriviaRepositoryMock();
  final useCase = GetRandomNumberTriviaUseCase(numberTriviaRepository);

  test("Should get trivia from the repository", () async {
    const trivia = NumberTrivia(text: "test", number: 1);

    when(() => numberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(trivia));

    final result = await useCase(NoParams());

    expect(result.foldRight(id, (r, previous) => r), isA<NumberTrivia>());
    expect(result.isRight(), true);

    verify(() => numberTriviaRepository.getRandomNumberTrivia()).called(1);
  });
}
