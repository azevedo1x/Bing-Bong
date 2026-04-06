import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/peak_colors.dart';
import '../logic/character_notifier.dart';
import '../logic/character_state.dart';
import 'widgets/about_sheet.dart';
import 'widgets/background.dart';
import 'widgets/bing_bong_widget.dart';
import 'widgets/im_bing_bong_button.dart';
import 'widgets/pulsing_tap_me.dart';

class CharacterPage extends ConsumerWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(characterProvider);

    return Scaffold(
      backgroundColor: PeakColors.deepPurple,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            color: PeakColors.deepPurple
                .withValues(alpha: state.isTalking ? 0.15 : 0.35),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTitle(context),
                const SizedBox(height: 12),
                _buildActionRow(context, ref),
                const Spacer(),
                _buildQuoteArea(context, state),
                const SizedBox(height: 24),
                _buildCharacter(state),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImBingBongButton(
          onTap: () => ref
              .read(characterProvider.notifier)
              .playSpecific('audio/im bing bong.mp3'),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => const AboutSheet(),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 0,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/about_icon.jpg',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'BING BONG',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: PeakColors.textGlow,
            letterSpacing: 4,
            shadows: kTextShadows,
          ),
    );
  }

  Widget _buildQuoteArea(BuildContext context, CharacterState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        height: 80,
        child: Center(
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
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildCharacter(CharacterState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: state.isTalking
            ? const [
                BoxShadow(
                  color: Color(0x50FFD54F),
                  blurRadius: 80,
                  spreadRadius: 25,
                ),
                BoxShadow(
                  color: Color(0x30B2FF59),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ]
            : const [],
      ),
      child: const BingBongWidget(),
    );
  }
}
