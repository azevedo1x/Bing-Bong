import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/character_notifier.dart';

class BingBongWidget extends ConsumerStatefulWidget {
  const BingBongWidget({super.key});

  @override
  ConsumerState<BingBongWidget> createState() => _BingBongWidgetState();
}

class _BingBongWidgetState extends ConsumerState<BingBongWidget>
    with TickerProviderStateMixin {
  late final AnimationController _idleController;
  late final AnimationController _bounceController;
  late final Animation<double> _floatAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 0.94)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    HapticFeedback.mediumImpact();
    _bounceController.forward(from: 0.0);
    await ref.read(characterProvider.notifier).onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_idleController, _bounceController]),
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: Transform.scale(scale: _scaleAnim.value, child: child),
        ),
        child: Image.asset(
          'assets/images/bing_bong.png',
          width: 280,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
