import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Konfiguracja motywu aplikacji z wykorzystaniem Material 3.
/// Automatycznie dostosowuje się do trybu jasnego / ciemnego.
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: 'NotoSerif',
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    fontFamily: 'NotoSerif',
  );
}