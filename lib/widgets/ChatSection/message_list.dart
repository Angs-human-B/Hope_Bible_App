import 'package:flutter/cupertino.dart';
import '../../widgets/ChatSection/chat_bubble.dart';
import '../../screens/chat_home_screen.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;

  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(

      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ChatBubble(text: msg.text, isUser: msg.isUser);
        },
      ),
    );
  }
}
