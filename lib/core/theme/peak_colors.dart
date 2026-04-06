import 'package:flutter/material.dart';

abstract final class PeakColors {
  static const deepPurple = Color(0xFF1A0A2E);
  static const midPurple = Color(0xFF2D1B69);
  static const accentCoral = Color(0xFFE8835A);
  static const accentCyan = Color(0xFF4DE8D3);
  static const accentYellow = Color(0xFFFFD54F);
  static const textPrimary = Color(0xFFE8E0F0);
  static const textGlow = Color(0xFFB2FF59);
  static const surface = Color(0xFF1E1235);
  static const surfaceLight = Color(0xFF2A1A4A);
}

const kTextShadows = [
  Shadow(color: Colors.black, blurRadius: 6, offset: Offset(2, 2)),
  Shadow(color: Colors.black, blurRadius: 16, offset: Offset(3, 3)),
];

const kCartoonBorder = BorderSide(color: Colors.black, width: 2.5);
