import 'package:flutter/material.dart';

/// Klasa z definicją bazowych kolorów aplikacji.
/// Używana do generowania ColorScheme dla Material 3.

class AppColors {
  // Kolor bazowy (primary seed)
  static const Color seedColor = Color(0xFF8B4513);

  // Dodatkowe kolory tematyczne
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFB00020);
  static const Color info = Color(0xFF2196F3);

  // Neutralne odcienie (opcjonalne)
  static const Color backgroundLight = Color(0xFFFFFAF2);
  static const Color backgroundDark = Color(0xFF1C1B1F);
}
