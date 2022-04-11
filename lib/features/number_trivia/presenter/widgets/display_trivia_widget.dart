import 'package:flutter/material.dart';
import 'package:flutter_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class DisplayTriviaWidget extends StatelessWidget {
  final NumberTrivia trivia;

  const DisplayTriviaWidget({Key? key, required this.trivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(trivia.number.toString(),
              style:
                  const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          Center(
            child: SingleChildScrollView(
              child: Text(
                trivia.text,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
