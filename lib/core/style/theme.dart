import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF884EA0),
      surfaceTint: Color(0xFF884EA0),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEAD8F5),
      onPrimaryContainer: Color(0xFF3A0D55),
      secondary: Color(0xFF6E6980),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE3DFF0),
      onSecondaryContainer: Color(0xFF292536),
      tertiary: Color(0xFF795298),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFEFDBFF),
      onTertiaryContainer: Color(0xFF3C1065),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFF8F6FC),
      onSurface: Color(0xFF1C1B1F),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFFD6B9EF),
      primaryFixed: Color(0xFFEAD8F5),
      onPrimaryFixed: Color(0xFF2A0045),
      primaryFixedDim: Color(0xFFD6B9EF),
      onPrimaryFixedVariant: Color(0xFF4E1A7F),
      secondaryFixed: Color(0xFFE3DFF0),
      onSecondaryFixed: Color(0xFF1E1C2C),
      secondaryFixedDim: Color(0xFFC7C3D3),
      onSecondaryFixedVariant: Color(0xFF3D3B4D),
      tertiaryFixed: Color(0xFFEFDBFF),
      onTertiaryFixed: Color(0xFF2C0A48),
      tertiaryFixedDim: Color(0xFFD3BBF2),
      onTertiaryFixedVariant: Color(0xFF491A6B),
      surfaceDim: Color(0xFFD8D7DD),
      surfaceBright: Color(0xFFF8F6FC),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF2EFF7),
      surfaceContainer: Color(0xFFEDEAF3),
      surfaceContainerHigh: Color(0xFFE7E5EC),
      surfaceContainerHighest: Color(0xFFE2E0E8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD6B9EF),
      surfaceTint: Color(0xFFD6B9EF),
      onPrimary: Color(0xFF3C0068),
      primaryContainer: Color(0xFF603A8A),
      onPrimaryContainer: Color(0xFFEAD8F5),
      secondary: Color(0xFFC7C3D3),
      onSecondary: Color(0xFF302C3C),
      secondaryContainer: Color(0xFF474255),
      onSecondaryContainer: Color(0xFFE3DFF0),
      tertiary: Color(0xFFD3BBF2),
      onTertiary: Color(0xFF3E1065),
      tertiaryContainer: Color(0xFF5B2D91),
      onTertiaryContainer: Color(0xFFEFDBFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF141218),
      onSurface: Color(0xFFE4E1EA),
      onSurfaceVariant: Color(0xFFC7C5D0),
      outline: Color(0xFF918F9B),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE4E1EA),
      inversePrimary: Color(0xFF884EA0),
      primaryFixed: Color(0xFFEAD8F5),
      onPrimaryFixed: Color(0xFF2A0045),
      primaryFixedDim: Color(0xFFD6B9EF),
      onPrimaryFixedVariant: Color(0xFF4E1A7F),
      secondaryFixed: Color(0xFFE3DFF0),
      onSecondaryFixed: Color(0xFF1E1C2C),
      secondaryFixedDim: Color(0xFFC7C3D3),
      onSecondaryFixedVariant: Color(0xFF3D3B4D),
      tertiaryFixed: Color(0xFFEFDBFF),
      onTertiaryFixed: Color(0xFF2C0A48),
      tertiaryFixedDim: Color(0xFFD3BBF2),
      onTertiaryFixedVariant: Color(0xFF491A6B),
      surfaceDim: Color(0xFF141218),
      surfaceBright: Color(0xFF2A2830),
      surfaceContainerLowest: Color(0xFF0F0D13),
      surfaceContainerLow: Color(0xFF1A1820),
      surfaceContainer: Color(0xFF211F27),
      surfaceContainerHigh: Color(0xFF2C2A32),
      surfaceContainerHighest: Color(0xFF37353D),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData lightWithCustomStyles() {
    final baseTheme = light();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  ThemeData darkWithCustomStyles() {
    final baseTheme = dark();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      fontFamily: "Quicksand",
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    fontFamily: "Quicksand",
    fontFamilyFallback: ["Quicksand"],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.surfaceContainerLowest,
        backgroundColor: colorScheme.primary,
        elevation: 0,
        textStyle: TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentTextStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        fontFamily: "Quicksand",
      ),
    ),
  );

  List<ExtendedColor> get extendedColors => [];
}

InputDecoration customInputDecoration({
  required String label,
  IconData? prefixIcon,
  Widget? suffixIcon,
  EdgeInsets prefixMargin = const EdgeInsets.only(left: 10.0),
  EdgeInsets suffixMargin = const EdgeInsets.only(right: 8.0),
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon:
        prefixIcon != null
            ? Container(margin: prefixMargin, child: Icon(prefixIcon))
            : null,
    suffixIcon:
        suffixIcon != null
            ? Container(margin: suffixMargin, child: suffixIcon)
            : null,
  );
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
