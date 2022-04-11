import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  const numberTriviaModel = NumberTriviaModel(number: 1, text: "Test");

  test("Should be a subclass of NumberTrivia", () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test(
      "Should return a valid model when JSON number is an integer",
      () async {
        Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, numberTriviaModel);
      },
    );

    test(
      "Should return a valid model when JSON number is regarded as a double",
      () async {
        Map<String, dynamic> jsonMap =
            json.decode(fixture("trivia_double.json"));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, numberTriviaModel);
      },
    );
  });

  group("toJson", () {
    test("Should return a JSON map containing the proper data", () {
      final result = numberTriviaModel.toJson();

      final expectedMap = {
        "text": "Test",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
