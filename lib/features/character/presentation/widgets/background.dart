import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/peak_colors.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Image.asset(
        'assets/images/background.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [PeakColors.midPurple, PeakColors.deepPurple],
            ),
          ),
        ),
      ),
    );
  }
}
