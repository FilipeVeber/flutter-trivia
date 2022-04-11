import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/utils/input_converter.dart';

main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test(
        "Should return an Integer when the string represents an unsigned integer",
        () {
      const str = "123";

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });

    test("Should return a Failure when the string is not an integer", () {
      const str = "abc";

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test("Should return a Failure when the string is a negative integer", () {
      const str = "-123";

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
