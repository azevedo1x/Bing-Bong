import 'package:flutter/material.dart';

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE8835A),
        brightness: Brightness.dark,
      ),
      fontFamily: 'DarumadropOne',
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
            fontFamily: 'DarumadropOne',
          ),
      scaffoldBackgroundColor: Colors.black,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
