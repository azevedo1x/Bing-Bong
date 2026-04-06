import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/splash/presentation/splash_page.dart';
import 'app_theme.dart';

class BingBongApp extends StatelessWidget {
  const BingBongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Bing Bong',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const SplashPage(),
      ),
    );
  }
}
