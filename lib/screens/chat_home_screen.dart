import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For colors only
import '../../widgets/ChatSection/app_bar_header.dart';
import '../../widgets/ChatSection/voice_greeting_box.dart';
import '../../widgets/ChatSection/suggestion_card.dart';
import '../../widgets/ChatSection/chat_input_bar.dart';
import '../../widgets/ChatSection/chat_bubble.dart';
import '../../widgets/ChatSection/message_list.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  bool _hasStartedChat = false;
  bool _isGenerating = false;

  late final AnimationController _titleAnimationController;
  late final Animation<double> _titleFade;

  @override
  void initState() {
    super.initState();
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _titleFade = CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeIn,
    );
  }

  void _sendMessage(String userText) {
    if (userText.isEmpty) return;

    if (!_hasStartedChat) {
      setState(() {
        _hasStartedChat = true;
      });
      _titleAnimationController.forward();
    }

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isGenerating = true;
      _controller.clear();
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                'The son of David, the son of Abraham. Abraham begat Isaac...',
            isUser: false,
          ),
        );
        _isGenerating = false;
      });
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0C111D),
      child: SafeArea(
        child: Column(
          children: [
            AppBarHeader(
              title:
                  _hasStartedChat
                      ? FadeTransition(
                        opacity: _titleFade,
                        child: const Text(
                          "Morning Verse",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                      : null,
              showMenu: !_hasStartedChat,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child:
                          !_hasStartedChat
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const VoiceGreetingBox(userName: 'John'),
                                  const Spacer(),
                                  SizedBox(
                                    height: 140,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: const [
                                        SuggestionCard(
                                          iconPath:
                                              'assets/icons/chat_home_1.svg',
                                          label:
                                              'Explain Matthew 5 in\nsimple terms.',
                                        ),
                                        SuggestionCard(
                                          iconPath:
                                              'assets/icons/chat_home_2.svg',
                                          label:
                                              'How can I grow\nspiritually every day?',
                                        ),
                                        SuggestionCard(
                                          iconPath:
                                              'assets/icons/chat_home_3.svg',
                                          label:
                                              'Help me with\na prayer for peace.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                              : MessageList(messages: _messages),
                    ),
                    const SizedBox(height: 10),
                    if (_isGenerating)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            "Generating...",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ChatInputBar(
                      controller: _controller,
                      onSend: () => _sendMessage(_controller.text.trim()),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
