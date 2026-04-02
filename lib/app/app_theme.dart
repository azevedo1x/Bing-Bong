import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE8835A),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.darumadropOneTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      scaffoldBackgroundColor: Colors.black,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
