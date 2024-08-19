import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primary = const Color.fromARGB(255, 243, 33, 33);
Color secondary = const Color.fromARGB(255, 244, 241, 54);
const Color tertiary = Colors.black;
Color white = Colors.white;

//ThemeData
//
ThemeData theme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: tertiary,
    ),
    bodyMedium: TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: tertiary),
    headlineMedium: TextStyle(color: tertiary, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: tertiary),
    titleLarge: TextStyle(
        color: tertiary.withOpacity(0.87), fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: tertiary, fontWeight: FontWeight.normal),
    titleSmall: TextStyle(color: tertiary, fontWeight: FontWeight.normal),
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
      primary: primary,
      secondary: secondary,
      error: Colors.red.shade300),

  //InputDecorationTheme
  //
  inputDecorationTheme: InputDecorationTheme(
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
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(fontWeight: FontWeight.bold),
      bodySmall: TextStyle(fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: white),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: white),
      titleLarge: TextStyle(
          color: tertiary.withOpacity(0.87), fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontWeight: FontWeight.normal),
      titleSmall: TextStyle(fontWeight: FontWeight.normal),
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

    //Color Scheme
    //
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
    ));
