import 'dart:convert';

import 'package:flutter_trivia/core/error/exceptions.dart';
import 'package:flutter_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INumberTriviaLocalDataSource {
  /// Gets cached [NumberTriciaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel trivia);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSource implements INumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSource({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, jsonEncode(trivia.toJson()));
  }
}
