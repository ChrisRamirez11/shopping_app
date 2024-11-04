import 'package:flutter/material.dart';

const Color primary = const Color(0xFFF18427);
const Color secondary = const Color(0xFFF1EAB9);
const Color tertiary = Colors.black;
const Color white = Color(0xFFF9F6ED);
Color errorColor = Colors.red.shade300;

const double largeSize = 20;
const double mediumSize = 16;
const double smallSize = 12;

//ThemeData
//
ThemeData theme = ThemeData(
  primaryColor: white,
  textTheme: TextTheme(
    bodyLarge: const TextStyle(
      fontSize: largeSize, color: tertiary, fontWeight: FontWeight.bold),
    bodyMedium: const TextStyle(
        fontSize: mediumSize, color: tertiary, fontWeight: FontWeight.bold),
    bodySmall: const TextStyle(
        fontSize: smallSize, color: tertiary, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(
        fontWeight: FontWeight.normal, fontSize: largeSize, color: tertiary),
    labelMedium: TextStyle(
        fontWeight: FontWeight.normal, fontSize: mediumSize, color: tertiary),
    labelSmall: TextStyle(
        fontWeight: FontWeight.normal, fontSize: smallSize, color: tertiary),
  ),

  //SnackBarTheme
  //
  snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),

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
      bodyLarge: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: largeSize, color: white),
      bodyMedium: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: mediumSize, color: white),
      bodySmall: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: smallSize, color: white),
      labelLarge: const TextStyle(
          fontWeight: FontWeight.normal, fontSize: largeSize, color: white),
      labelMedium: const TextStyle(
          fontWeight: FontWeight.normal, fontSize: mediumSize, color: white),
      labelSmall: const TextStyle(
          fontWeight: FontWeight.normal, fontSize: smallSize, color: white),
    ),
    //SnackBarTheme
    //
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),

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
      tertiary: Color(0xFF57B35F)
    ));
