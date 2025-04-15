import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Only used for colors like Color(0xFFFFC943)

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          if (!isUser)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                CupertinoIcons.refresh_thin,
                color: CupertinoColors.systemGrey,
                size: 20,
              ),
            ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              constraints: const BoxConstraints(maxWidth: 260),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFFFFC943) : const Color(0xFF1C1F24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.black : CupertinoColors.white,
                ),
              ),
            ),
          ),

          if (isUser)
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: CupertinoColors.systemGrey3,
              ),
            ),
        ],
      ),
    );
  }
}
