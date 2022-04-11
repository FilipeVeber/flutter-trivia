import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_bloc.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/blocs/number_trivia_state.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/widgets/display_message_widget.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/widgets/display_trivia_widget.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/widgets/loading_widget.dart';
import 'package:flutter_trivia/features/number_trivia/presenter/widgets/trivia_controls_widget.dart';
import 'package:flutter_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  final NumberTriviaBloc bloc = serviceLocator.get();

  NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: BlocProvider<NumberTriviaBloc>(
          create: (_) => serviceLocator<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const DisplayMessageWidget(
                            message: "Start searching!");
                      }

                      if (state is Loading) {
                        return const LoadingWidget();
                      }

                      if (state is Error) {
                        return DisplayMessageWidget(message: state.message);
                      }

                      return DisplayTriviaWidget(
                          trivia: (state as Loaded).trivia);
                    },
                  ),
                  const SizedBox(height: 20),
                  const TriviaControls()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
