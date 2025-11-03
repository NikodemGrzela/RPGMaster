import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';

/// Wszystkie ścieżki aplikacji w jednym miejscu
class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';

  /// Funkcja generująca trasy dynamicznie
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 – Nie znaleziono strony')),
          ),
        );
    }
  }
}
