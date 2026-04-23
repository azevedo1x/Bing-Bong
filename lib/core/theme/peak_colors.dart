import 'package:flutter/material.dart';

abstract final class PeakColors {
  static const deepPurple = Color(0xFF1A0A2E);
  static const midPurple = Color(0xFF2D1B69);
  static const vignetteEdge = Color(0xFF0A0418);
  static const accentCoral = Color(0xFFE8835A);
  static const accentCyan = Color(0xFF4DE8D3);
  static const accentYellow = Color(0xFFFFD54F);
  static const textPrimary = Color(0xFFE8E0F0);
  static const textMuted = Color(0xFFB8A8D0);
  static const textGlow = Color(0xFFB2FF59);
  static const surface = Color(0xFF1E1235);
  static const surfaceLight = Color(0xFF2A1A4A);

  static const idleGlow = Color(0xFFB2FF59);
  static const talkGlow = Color(0xFFFFD54F);
  static const warmLeak = Color(0xFFE8835A);
  static const coolLeak = Color(0xFF4DE8D3);
}

const kTextShadows = [
  Shadow(color: Color(0xCC000000), blurRadius: 12, offset: Offset(0, 2)),
];
