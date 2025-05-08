import 'package:flutter/material.dart';

TextTheme createTextTheme(BuildContext context) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;

  return baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: "Quicksand"),
    displayMedium: baseTextTheme.displayMedium?.copyWith(
      fontFamily: "Quicksand",
    ),
    displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: "Quicksand"),
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(
      fontFamily: "Quicksand",
    ),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(
      fontFamily: "Quicksand",
    ),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(
      fontFamily: "Quicksand",
    ),
    titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: "Quicksand"),
    titleMedium: baseTextTheme.titleMedium?.copyWith(fontFamily: "Quicksand"),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontFamily: "Quicksand"),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontFamily: "Quicksand"),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontFamily: "Quicksand"),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontFamily: "Quicksand"),
    labelLarge: baseTextTheme.labelLarge?.copyWith(fontFamily: "Quicksand"),
    labelMedium: baseTextTheme.labelMedium?.copyWith(fontFamily: "Quicksand"),
    labelSmall: baseTextTheme.labelSmall?.copyWith(fontFamily: "Quicksand"),
  );
}
