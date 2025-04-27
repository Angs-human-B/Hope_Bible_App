import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarHeader extends StatelessWidget {
  final Widget? title;
  final bool showMenu;

  const AppBarHeader({super.key, this.title, this.showMenu = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.back,
                  color: CupertinoColors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                child: title ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
