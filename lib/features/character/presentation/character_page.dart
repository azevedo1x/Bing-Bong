import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/character_notifier.dart';
import 'widgets/bing_bong_widget.dart';

const _limeGreen = Color(0xFFB2FF59);

const _textShadows = [
  Shadow(color: Colors.black, blurRadius: 8, offset: Offset(1, 1)),
  Shadow(color: Colors.black, blurRadius: 20, offset: Offset(2, 2)),
];

class CharacterPage extends ConsumerWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(characterProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _Background(),

          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            color: Colors.black
                .withValues(alpha: state.isTalking ? 0.3 : 0.55),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),

                Text(
                  'BING BONG',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: _limeGreen,
                        letterSpacing: 3,
                        shadows: _textShadows,
                      ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 80,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: state.isTalking
                          ? Text(
                              state.quote,
                              key: ValueKey(state.quote),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: _limeGreen,
                                    fontStyle: FontStyle.italic,
                                    shadows: _textShadows,
                                  ),
                            )
                          : const _PulsingTapMe(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: state.isTalking
                        ? const [
                            BoxShadow(
                              color: Color(0x55B2FF59),
                              blurRadius: 100,
                              spreadRadius: 30,
                            ),
                            BoxShadow(
                              color: Color(0x30B2FF59),
                              blurRadius: 60,
                              spreadRadius: 10,
                            ),
                          ]
                        : const [],
                  ),
                  child: const BingBongWidget(),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingTapMe extends StatefulWidget {
  const _PulsingTapMe();

  @override
  State<_PulsingTapMe> createState() => _PulsingTapMeState();
}

class _PulsingTapMeState extends State<_PulsingTapMe>
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
        opacity: 0.35 + _controller.value * 0.45,
        child: child,
      ),
      child: Text(
        'TAP ME',
        key: const ValueKey('tap_me'),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _limeGreen,
              letterSpacing: 6,
              shadows: _textShadows,
            ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
              colors: [Color(0xFF1A0A2E), Color(0xFF0D0015)],
            ),
          ),
        ),
      ),
    );
  }
}
