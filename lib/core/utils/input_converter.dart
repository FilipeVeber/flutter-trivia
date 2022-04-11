import 'package:dartz/dartz.dart';
import 'package:flutter_trivia/core/error/failures.dart';

class InputConverter {
  Either<InvalidInputFailure, int> stringToUnsignedInteger(String str) {
    try {
      final result = int.parse(str);

      if (result < 0) {
        throw const FormatException();
      }

      return Right(result);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
