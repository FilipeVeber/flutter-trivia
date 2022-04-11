import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/repositories/number_trivia_repository_interface.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:mocktail/mocktail.dart';

class NumberTriviaRepositoryMock extends Mock
    implements INumberTriviaRepository {}

main() {
  final numberTriviaRepository = NumberTriviaRepositoryMock();
  final useCase = GetConcreteNumberTriviaUseCase(numberTriviaRepository);

  test("Should get trivia for the number from the repository", () async {
    const number = 1;
    const trivia = NumberTrivia(text: "test", number: number);

    when(() => numberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(trivia));

    final result = await useCase(const Params(number: number));

    expect(result.foldRight(id, (r, previous) => r), isA<NumberTrivia>());
    expect(result.isRight(), true);

    verify(() => numberTriviaRepository.getConcreteNumberTrivia(any()))
        .called(1);
  });
}
