import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_theme.dart';
import '../../../core/theme/peak_colors.dart';
import '../logic/character_notifier.dart';
import '../logic/character_state.dart';
import 'widgets/about_sheet.dart';
import 'widgets/ambient_glow.dart';
import 'widgets/background.dart';
import 'widgets/bing_bong_widget.dart';
import 'widgets/glass_icon_button.dart';
import 'widgets/im_bing_bong_button.dart';
import 'widgets/pulsing_tap_me.dart';
import 'widgets/shockwave.dart';

class CharacterPage extends ConsumerStatefulWidget {
  const CharacterPage({super.key});

  @override
  ConsumerState<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends ConsumerState<CharacterPage> {
  final ShockwaveController _shockwave = ShockwaveController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: PeakColors.deepPurple,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(isTalking: state.isTalking),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  const _Title(),
                  const SizedBox(height: 14),
                  _ActionRow(
                    onImBingBong: () {
                      _shockwave.pulse();
                      ref
                          .read(characterProvider.notifier)
                          .playSpecific('audio/im bing bong.mp3');
                    },
                    onAbout: () => _openAbout(context),
                  ),
                  const Spacer(),
                  _QuoteArea(state: state),
                  const SizedBox(height: 28),
                  _Character(state: state, shockwave: _shockwave),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      isScrollControlled: true,
      builder: (_) => const AboutSheet(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'BING BONG',
          style: TextStyle(
            fontFamily: kCharacterFont,
            fontSize: 34,
            letterSpacing: 6,
            color: PeakColors.textGlow,
            shadows: kTextShadows,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 44,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.0),
                PeakColors.accentCoral.withValues(alpha: 0.85),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onImBingBong;
  final VoidCallback onAbout;

  const _ActionRow({required this.onImBingBong, required this.onAbout});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImBingBongButton(onTap: onImBingBong),
        const SizedBox(width: 18),
        GlassIconButton(
          asset: 'assets/images/about_icon.jpg',
          tint: PeakColors.accentCyan,
          onTap: onAbout,
        ),
      ],
    );
  }
}

class _QuoteArea extends StatelessWidget {
  final CharacterState state;

  const _QuoteArea({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 110,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: state.isTalking
                ? Text(
                    state.quote,
                    key: ValueKey(state.quote),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: kCharacterFont,
                      fontSize: 26,
                      height: 1.2,
                      color: PeakColors.accentYellow,
                      fontStyle: FontStyle.italic,
                      shadows: kTextShadows,
                    ),
                  )
                : const PulsingTapMe(),
          ),
        ),
      ),
    );
  }
}

class _Character extends StatelessWidget {
  final CharacterState state;
  final ShockwaveController shockwave;

  const _Character({required this.state, required this.shockwave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ShockwaveLayer(controller: shockwave, size: 320),
          AmbientGlow(
            active: state.isTalking,
            child: BingBongWidget(shockwave: shockwave),
          ),
        ],
      ),
    );
  }
}
