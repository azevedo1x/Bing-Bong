import 'package:flutter/material.dart';
import '../core/theme/peak_colors.dart';

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PeakColors.accentCoral,
        brightness: Brightness.dark,
        surface: PeakColors.surface,
      ),
      fontFamily: 'DarumadropOne',
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
            fontFamily: 'DarumadropOne',
          ),
      scaffoldBackgroundColor: PeakColors.deepPurple,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
