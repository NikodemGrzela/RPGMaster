import 'package:flutter/material.dart';

class ButtonLoginWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonLoginWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 152,
        height: 76,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), // Prostszy zapis
                  color: const Color.fromRGBO(140, 62, 5, 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 8), // Usunięty null
                          const Text(
                            'Log In',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(254, 248, 241, 1),
                              fontFamily: 'Noto Serif',
                              fontSize: 32,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}