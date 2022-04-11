import 'package:equatable/equatable.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  final List<Object> properties;

  const NumberTriviaState([this.properties = const []]);

  @override
  List<Object> get props => properties;
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia}) : super([trivia]);
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message}) : super([message]);
}
