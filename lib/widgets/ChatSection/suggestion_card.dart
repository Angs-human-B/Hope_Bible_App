import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For color constants
import 'package:flutter_svg/flutter_svg.dart';

class SuggestionCard extends StatelessWidget {
  final String iconPath;
  final String label;

  const SuggestionCard({
    super.key,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF080C14),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  CupertinoColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
