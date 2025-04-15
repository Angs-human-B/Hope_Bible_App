import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For some custom colors
import '../../screens/ai_call_screen.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Input Box
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF444444),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.add_circled,
                  color: Color(0xFFCCCCCC),
                  size: 20,
                ),
                const SizedBox(width: 8),

 
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    style: const TextStyle(color: Color(0xFFCCCCCC)),
                    placeholder: 'Ask Bible AI...',
                    placeholderStyle: const TextStyle(
                      color: CupertinoColors.systemGrey2,
                    ),
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(color: Color(0xFF444444)),
                    onSubmitted: (_) => onSend(),
                  ),
                ),


                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onSend,
                  child: const Icon(
                    CupertinoIcons.paperplane_fill,
                    color: CupertinoColors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),


        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => const AICallScreen(userName: "John"),
              ),
            );
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFC943),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.mic_fill, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
