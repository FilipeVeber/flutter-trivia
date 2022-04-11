import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/error/exceptions.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

main() {
  late SharedPreferencesMock sharedPreferencesMock;
  late NumberTriviaLocalDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cache.json"))));
  });

  setUp(() {
    sharedPreferencesMock = SharedPreferencesMock();
    dataSource =
        NumberTriviaLocalDataSource(sharedPreferences: sharedPreferencesMock);
  });

  group("getNumberTrivia", () {
    final triviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cache.json")));

    test(
        "Should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      when(() => sharedPreferencesMock.getString(any()))
          .thenReturn(fixture("trivia_cache.json"));

      final result = await dataSource.getNumberTrivia();

      verify(() => sharedPreferencesMock.getString(CACHED_NUMBER_TRIVIA));
      expect(result, triviaModel);
    });

    test("Should throw a CacheException when there is not a cached value",
        () async {
      when(() => sharedPreferencesMock.getString(any())).thenReturn(null);

      final call = dataSource.getNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    const triviaToCache = NumberTriviaModel(text: "Test", number: 1);

    test("Should call SharedPreferences to cache the data", () {
      when(() => dataSource.cacheNumberTrivia(triviaToCache))
          .thenAnswer((_) => Future.value());

      when(() => sharedPreferencesMock.setString(CACHED_NUMBER_TRIVIA, any()))
          .thenAnswer((_) => Future.value(true));

      dataSource.cacheNumberTrivia(triviaToCache);

      final expectedJsonString = json.encode(triviaToCache.toJson());
      verify(() => sharedPreferencesMock.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
