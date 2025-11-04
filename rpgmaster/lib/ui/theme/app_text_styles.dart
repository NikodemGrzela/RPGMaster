import 'package:flutter/material.dart';

class AppTextStyles {

  /// Logo font
  static const TextStyle logo = TextStyle(
    fontFamily: 'UncialAntiqua',
    fontWeight: FontWeight.w300,
    fontSize: 64,
  );

  /// Big headlines
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  /// Regular headlines
  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  /// Regular text
  static const TextStyle body = TextStyle(
    fontSize: 18,
  );

  /// Small text
  static const TextStyle label = TextStyle(
    fontSize: 14,
    letterSpacing: 0.5,
  );
}
