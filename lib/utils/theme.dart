import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
  ),
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
