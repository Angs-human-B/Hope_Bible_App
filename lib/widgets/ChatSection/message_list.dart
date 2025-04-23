import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String displayedText;
  final bool isTyping;
  final bool isGenerating;
  final Animation<double> shimmerAnimation;

  const MessageList({
    Key? key,
    required this.messages,
    this.displayedText = '',
    this.isTyping = false,
    this.isGenerating = false,
    required this.shimmerAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(bottom: isGenerating && !isTyping ? 80 : 0),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];
            final isLastMessage = index == 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment:
                    message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  if (!message.isUser)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2F35),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.person_fill,
                          color: CupertinoColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            message.isUser
                                ? const Color(0xFF2C2F35)
                                : const Color(0xFF1E2127),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child:
                          isLastMessage && !message.isUser && isTyping
                              ? Text(
                                displayedText,
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                ),
                              )
                              : Text(
                                message.text,
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (message.isUser)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2F35),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.person_fill,
                          color: CupertinoColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        // Shimmer loading indicator at the bottom left
        if (isGenerating && !isTyping)
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2F35),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: CupertinoColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2127),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _buildShimmerEffect(),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF1E2127),
                Color(0xFF2C2F35),
                Color(0xFF1E2127),
              ],
              stops: [0.0, shimmerAnimation.value, 1.0],
            ).createShader(bounds);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
