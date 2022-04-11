import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/use_cases/use_case.dart';
import 'package:flutter_trivia/core/utils/input_converter.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_bloc.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_event.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_state.dart';
import 'package:mocktail/mocktail.dart';

class GetConcreteNumberTriviaUseCaseMock extends Mock
    implements GetConcreteNumberTriviaUseCase {}

class GetRandomNumberTriviaUseCaseMock extends Mock
    implements GetRandomNumberTriviaUseCase {}

class InputConverterMock extends Mock implements InputConverter {}

main() {
  late GetConcreteNumberTriviaUseCaseMock getConcreteNumberTriviaUseCaseMock;
  late GetRandomNumberTriviaUseCaseMock getRandomNumberTriviaUseCaseMock;
  late InputConverterMock inputConverterMock;
  late NumberTriviaBloc bloc;

  setUpAll(() {
    registerFallbackValue(const Params(number: 1));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    getConcreteNumberTriviaUseCaseMock = GetConcreteNumberTriviaUseCaseMock();
    getRandomNumberTriviaUseCaseMock = GetRandomNumberTriviaUseCaseMock();
    inputConverterMock = InputConverterMock();
    bloc = NumberTriviaBloc(
      concreteUseCase: getConcreteNumberTriviaUseCaseMock,
      randomUseCase: getRandomNumberTriviaUseCaseMock,
      inputConverter: inputConverterMock,
    );
  });

  test("Should have an Empty initial state", () {
    expect(bloc.state, Empty());
  });

  group("GetTriviaForConcreteNumber", () {
    const numberString = "1";
    const numberParsed = 1;
    const numberTrivia = NumberTrivia(number: 1, text: "Test");

    void setUpInputConverterMockSuccess() =>
        when(() => inputConverterMock.stringToUnsignedInteger(any()))
            .thenReturn(const Right(numberParsed));

    test(
        "Should call the InputConverter to validate and convert the string to an unsigned integer",
        () async {
      setUpInputConverterMockSuccess();

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(
          () => inputConverterMock.stringToUnsignedInteger(any()));

      verify(() => inputConverterMock.stringToUnsignedInteger(numberString));
    });

    test("Should return the parsed number the string to an unsigned integer",
        () async {
      setUpInputConverterMockSuccess();

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(
          () => inputConverterMock.stringToUnsignedInteger(any()));

      verify(() => inputConverterMock.stringToUnsignedInteger(numberString));
    });

    test("Should emit [Error] state when the input is invalid", () async {
      when(() => inputConverterMock.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];

      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString));
    });

    test("Should get data from the concrete use case", () async {
      setUpInputConverterMockSuccess();

      when(() => getConcreteNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => const Right(numberTrivia));

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(() => getConcreteNumberTriviaUseCaseMock(any()));

      verify(() => getConcreteNumberTriviaUseCaseMock(
          const Params(number: numberParsed)));
    });

    test("Should emit [Loading, Loaded] when data is gotten successfully",
        () async {
      setUpInputConverterMockSuccess();

      when(() => getConcreteNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => const Right(numberTrivia));

      final expected = [
        Loading(),
        Loaded(trivia: numberTrivia),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(() => getConcreteNumberTriviaUseCaseMock(any()));
    });

    test("Should emit [Loading, Error] when getting data fails", () async {
      setUpInputConverterMockSuccess();

      when(() => getConcreteNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(() => getConcreteNumberTriviaUseCaseMock(any()));
    });

    test(
        "Should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
      setUpInputConverterMockSuccess();

      when(() => getConcreteNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(() => getConcreteNumberTriviaUseCaseMock(any()));
    });
  });

  group("GetTriviaForRandomNumber", () {
    const numberTrivia = NumberTrivia(number: 1, text: "Test");

    test("Should get data from the random use case", () async {
      when(() => getRandomNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => const Right(numberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => getRandomNumberTriviaUseCaseMock(any()));

      verify(() => getRandomNumberTriviaUseCaseMock(NoParams()));
    });

    test("Should emit [Loading, Loaded] when data is gotten successfully",
        () async {
      when(() => getRandomNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => const Right(numberTrivia));

      final expected = [
        Loading(),
        Loaded(trivia: numberTrivia),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test("Should emit [Loading, Error] when getting data fails", () async {
      when(() => getRandomNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        "Should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
      when(() => getRandomNumberTriviaUseCaseMock(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
