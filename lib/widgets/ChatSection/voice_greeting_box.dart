import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/utilities/text.utility.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AllText(
                text: "Hello, ",
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Inter',
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AllText(
                text: userName,
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Inter',
                  color: Color(0xFFFFC13C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          AllText(
            text: "How can I help?",
            style: const TextStyle(
              fontSize: 30,
              fontFamily: 'Inter',
              color: CupertinoColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
