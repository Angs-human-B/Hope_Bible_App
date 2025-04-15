import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
class RoundedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const RoundedButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFF2C2F35),
    this.iconColor = CupertinoColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}
