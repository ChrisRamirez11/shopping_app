import 'package:flutter/material.dart';

Color primary = const Color.fromARGB(255, 243, 33, 33);
Color secondary = const Color.fromARGB(255, 244, 241, 54);
const Color tertiary = Colors.black;
Color white = Colors.white;

//ThemeData
//
ThemeData theme = ThemeData(
  primaryColor: white,
  textTheme: TextTheme(
    bodyLarge: const TextStyle(
      color: tertiary,
    ),
    bodyMedium: const TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    bodySmall: const TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    headlineLarge: const TextStyle(color: tertiary),
    headlineMedium:
        const TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    headlineSmall: const TextStyle(color: tertiary),
    titleLarge: TextStyle(
        color: tertiary.withOpacity(0.87), fontWeight: FontWeight.bold),
    titleMedium:
        const TextStyle(color: tertiary, fontWeight: FontWeight.normal),
    titleSmall: const TextStyle(color: tertiary, fontWeight: FontWeight.normal),
  ),

  //ScrollbarTheme
  //
  scrollbarTheme: const ScrollbarThemeData(
    trackVisibility: WidgetStatePropertyAll(true),
    interactive: true,
    thickness: WidgetStatePropertyAll(8),
    thumbVisibility: WidgetStatePropertyAll(true),
  ),

  //ColorScheme
  //
  colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      error: Colors.red.shade300),

  //InputDecorationTheme
  //
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: tertiary,
    labelStyle: TextStyle(color: tertiary),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: tertiary),
    ),
  ),

  //TextSelectionTheme
  //
  textSelectionTheme: TextSelectionThemeData(
      cursorColor: tertiary,
      selectionColor: tertiary.withOpacity(0.30),
      selectionHandleColor: tertiary.withOpacity(0.8)),

  useMaterial3: true,
);

//ThemeData
//
ThemeData themeDark = ThemeData.dark().copyWith(
    textTheme: TextTheme(
      bodyLarge: const TextStyle(),
      bodyMedium: const TextStyle(fontWeight: FontWeight.bold),
      bodySmall: const TextStyle(fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: white),
      headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: white),
      titleLarge: TextStyle(
          color: tertiary.withOpacity(0.87), fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(fontWeight: FontWeight.normal),
      titleSmall: const TextStyle(fontWeight: FontWeight.normal),
    ),

    //ScrollbarTheme
    //
    scrollbarTheme: const ScrollbarThemeData(
      trackVisibility: WidgetStatePropertyAll(true),
      interactive: true,
      thickness: WidgetStatePropertyAll(8),
      thumbVisibility: WidgetStatePropertyAll(true),
    ),

    //InputDecorationTheme
    //
    inputDecorationTheme: InputDecorationTheme(
      focusColor: white,
      labelStyle: TextStyle(color: white),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white),
      ),
    ),

    //TextSelectionTheme
    //
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: white,
        selectionColor: white.withOpacity(0.30),
        selectionHandleColor: white.withOpacity(0.8)),
    cardColor: primary.withOpacity(0.1),
    //Color Scheme
    //
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
    ));
