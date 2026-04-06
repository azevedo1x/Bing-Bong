import 'package:flutter/material.dart';
import '../../../../core/theme/peak_colors.dart';

class PulsingTapMe extends StatefulWidget {
  const PulsingTapMe({super.key});

  @override
  State<PulsingTapMe> createState() => _PulsingTapMeState();
}

class _PulsingTapMeState extends State<PulsingTapMe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: 0.4 + _controller.value * 0.6,
        child: child,
      ),
      child: Text(
        'TAP ME',
        key: const ValueKey('tap_me'),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: PeakColors.accentYellow,
              letterSpacing: 6,
              shadows: kTextShadows,
            ),
      ),
    );
  }
}
