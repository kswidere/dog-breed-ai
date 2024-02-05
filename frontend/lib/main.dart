import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning/pages/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: GoogleFonts.balooBhaina2(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.balooBhaijaan2(
            fontSize: 20,
          ),
          displaySmall: GoogleFonts.balooBhaijaan2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: GoogleFonts.balooBhaina2(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffD9CD48),
            minimumSize: const Size(320, 48),
          ),
        )
      ),
      home: const Scaffold(
        body: HomePage(),
      ),
    );
  }
}
