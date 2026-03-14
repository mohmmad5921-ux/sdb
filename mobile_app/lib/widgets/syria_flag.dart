import 'package:flutter/material.dart';

/// Reusable widget for the new Syrian independence flag.
/// Use this instead of the 🇸🇾 emoji which shows the old flag.
class SyriaFlag extends StatelessWidget {
  final double size;
  const SyriaFlag({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.15),
      child: Image.asset(
        'assets/images/syria-flag.png',
        width: size * 1.5,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
