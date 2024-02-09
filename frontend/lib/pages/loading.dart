import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff112225), Color(0xff0B152A), Color(0xff1B1128)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Stack(
        children: [
          Center(child: Lottie.asset("assets/loading_animation.json")),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText('loading', textStyle: Theme.of(context).textTheme.labelMedium),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
                pause: const Duration(milliseconds: 0),
              ),
            ),
          )
        ],
      )
    );
  }
}