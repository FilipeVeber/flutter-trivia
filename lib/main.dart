import 'package:flutter/material.dart';
import 'package:flutter_trivia/injection_container.dart' as injection_container;

import 'features/number_trivia/presenter/pages/number_trivia_page.dart';

void main() async {
  await injection_container.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green.shade600)),
      home: NumberTriviaPage(),
    );
  }
}
