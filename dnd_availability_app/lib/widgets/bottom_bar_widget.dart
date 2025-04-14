import 'package:flutter/material.dart';

class BottomAppInfoBar extends StatelessWidget {
  final String version;

  const BottomAppInfoBar({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Image.asset(
            'assets/dragon_logo.png', // Ton icône générée
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 10),
          Text(
            'D&D&B — v$version',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'UncialAntiqua', // Si tu l’as intégrée
            ),
          ),
        ],
      ),
    );
  }
}
