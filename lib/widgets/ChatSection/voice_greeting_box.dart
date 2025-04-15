import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class VoiceGreetingBox extends StatelessWidget {
  final String userName;
  final bool filled;

  const VoiceGreetingBox({
    super.key,
    required this.userName,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFF1C1F24) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Inter',
            color: CupertinoColors.white,
            fontWeight: FontWeight.w500,
          ),
          children: [
            const TextSpan(text: "Hello, "),
            TextSpan(
              text: userName,
              style: const TextStyle(
                color: Color(0xFFFFC13C),
                fontFamily: 'Inter',
              ),
            ),
            const TextSpan(text: "\nHow can I help?"),
          ],
        ),
      ),
    );
  }
}
