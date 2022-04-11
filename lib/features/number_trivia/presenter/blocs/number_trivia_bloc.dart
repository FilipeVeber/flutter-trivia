import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_trivia/core/error/failures.dart';
import 'package:flutter_trivia/core/use_cases/use_case.dart';
import 'package:flutter_trivia/core/utils/input_converter.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_event.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_state.dart';

const SERVER_FAILURE_MESSAGE = "Server Failure";
const CACHE_FAILURE_MESSAGE = "Cache Failure";
const INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid input - The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTriviaUseCase concreteUseCase,
      required GetRandomNumberTriviaUseCase randomUseCase,
      required this.inputConverter})
      : getConcreteNumberTriviaUseCase = concreteUseCase,
        getRandomNumberTriviaUseCase = randomUseCase,
        super(Empty()) {
    setUpGetTriviaForConcreteNumberEvent();

    setUpGetTriviaForRandomNumberEvent();
  }

  void setUpGetTriviaForConcreteNumberEvent() {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.number);

      inputEither.fold(
        (failure) {
          emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (r) async {
          emit(Loading());

          final triviaOrFailure =
              await getConcreteNumberTriviaUseCase(Params(number: r));

          _eitherLoadedOrErrorState(emit, triviaOrFailure);
        },
      );
    });
  }

  void setUpGetTriviaForRandomNumberEvent() {
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final triviaOrFailure = await getRandomNumberTriviaUseCase(NoParams());

      _eitherLoadedOrErrorState(emit, triviaOrFailure);
    });
  }

  void _eitherLoadedOrErrorState(
    Emitter<NumberTriviaState> emit,
    Either<Failure, NumberTrivia> triviaOrFailure,
  ) {
    emit(triviaOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
