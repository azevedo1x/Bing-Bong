import 'package:flutter/material.dart';

class ImBingBongButton extends StatelessWidget {
  final VoidCallback onTap;
  const ImBingBongButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 2.5),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 0, offset: Offset(3, 3)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/im-bing-bong-button-img.jpg',
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
