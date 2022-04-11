import 'package:flutter/material.dart';

class DisplayMessageWidget extends StatelessWidget {
  final String message;

  const DisplayMessageWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height / 3,
    );
  }
}
