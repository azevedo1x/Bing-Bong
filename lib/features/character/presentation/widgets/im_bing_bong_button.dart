import 'package:flutter/material.dart';
import '../../../../core/theme/peak_colors.dart';
import 'glass_icon_button.dart';

class ImBingBongButton extends StatelessWidget {
  final VoidCallback onTap;

  const ImBingBongButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassIconButton(
      asset: 'assets/images/im-bing-bong-button-img.jpg',
      tint: PeakColors.accentCoral,
      onTap: onTap,
    );
  }
}
