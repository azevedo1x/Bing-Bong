import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/peak_colors.dart';

const _githubUrl = 'https://github.com/azevedo1x';

Future<void> _openGitHub() async {
  final uri = Uri.parse(_githubUrl);
  if (uri.scheme != 'https') return;
  if (!await canLaunchUrl(uri)) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        color: PeakColors.surface,
        border: Border(top: kCartoonBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: PeakColors.accentCoral,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/about_icon.jpg',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bing Bong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: PeakColors.textGlow,
                  shadows: kTextShadows,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'A Magic 8-Ball inspired by Peak',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PeakColors.textPrimary.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 20),
          _GitHubButton(),
          const SizedBox(height: 12),
          Text(
            'Tap Bing Bong and ask him anything!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PeakColors.textPrimary.withValues(alpha: 0.5),
                ),
          ),
        ],
      ),
    );
  }
}

class _GitHubButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openGitHub,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: PeakColors.accentCoral,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 0, offset: Offset(3, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.code_rounded, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '@azevedo1x',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
