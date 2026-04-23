import 'package:flutter/material.dart';
import '../../../../core/widgets/spring_pressable.dart';

class GlassIconButton extends StatelessWidget {
  final String asset;
  final Color tint;
  final VoidCallback onTap;
  final double size;
  final double borderRadius;

  const GlassIconButton({
    super.key,
    required this.asset,
    required this.tint,
    required this.onTap,
    this.size = 56,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return SpringPressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: tint.withValues(alpha: 0.28),
              blurRadius: 20,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: Color(0x66000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: radius,
              child: Image.asset(asset, fit: BoxFit.cover),
            ),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.white.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.18),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
