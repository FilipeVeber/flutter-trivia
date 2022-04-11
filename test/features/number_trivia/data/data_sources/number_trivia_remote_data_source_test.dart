import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia/core/error/exceptions.dart';
import 'package:flutter_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source_interface.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class HttpClientMock extends Mock implements http.Client {}

class NumberTriviaRemoteDataSourceMock extends Mock
    implements INumberTriviaRemoteDataSource {}

main() {
  late HttpClientMock httpClient;
  late NumberTriviaRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(Uri.parse("http://numbersapi.com/1"));
  });

  setUp(() {
    httpClient = HttpClientMock();
    dataSource = NumberTriviaRemoteDataSource(httpClient: httpClient);
  });

  void setUpHttpClientMockSuccess200() {
    when(() => httpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpHttpClientMockFailure404() {
    when(() => httpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    const number = 1;
    final triviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
        "Should perform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
      setUpHttpClientMockSuccess200();

      dataSource.getConcreteNumberTrivia(number);

      verify(() => httpClient.get(Uri.parse("http://numbersapi.com/$number"),
          headers: {"Content-Type": "application/json"}));
    });

    test("Should return NumberTriviaModel when the response code is 200",
        () async {
      setUpHttpClientMockSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(number);

      expect(result, triviaModel);
    });

    test("Should throw a ServerException when the response code is 404",
        () async {
      setUpHttpClientMockFailure404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(number), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final triviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test(
        "Should perform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
      setUpHttpClientMockSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(() => httpClient.get(Uri.parse("http://numbersapi.com/random"),
          headers: {"Content-Type": "application/json"}));
    });

    test("Should return NumberTriviaModel when the response code is 200",
        () async {
      setUpHttpClientMockSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, triviaModel);
    });

    test("Should throw a ServerException when the response code is 404",
        () async {
      setUpHttpClientMockFailure404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
