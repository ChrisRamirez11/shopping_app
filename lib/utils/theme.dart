import 'package:flutter/material.dart';

Color primary = const Color.fromARGB(255, 243, 33, 33);
Color secondary = const Color.fromARGB(255, 244, 241, 54);
ThemeData theme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
    bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
    titleSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
  ),
  scrollbarTheme: const ScrollbarThemeData(
    trackVisibility: MaterialStatePropertyAll(true),
    interactive: true,
    thickness: MaterialStatePropertyAll(8),
    thumbVisibility: MaterialStatePropertyAll(true),
  ),

  primaryColor: primary,
  // Color azul
  secondaryHeaderColor: secondary, // Color rojo

  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

ThemeData theme2 = ThemeData(
  scrollbarTheme: const ScrollbarThemeData(
    trackVisibility: MaterialStatePropertyAll(true),
    interactive: true,
    thickness: MaterialStatePropertyAll(8),
    thumbVisibility: MaterialStatePropertyAll(true),
  ),

  primaryColor: const Color.fromARGB(255, 243, 33, 33),
  // Color azul
  secondaryHeaderColor: const Color.fromARGB(255, 244, 241, 54), // Color rojo

  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
