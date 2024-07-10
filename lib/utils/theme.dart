import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  scrollbarTheme: const ScrollbarThemeData(
    trackVisibility:  MaterialStatePropertyAll(true),
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
