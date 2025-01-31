import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    scaffoldBackgroundColor: Color(0xFFFBF5DD),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.amber,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.deepPurple,
      secondary: Colors.amber,
    ),
  );
}
