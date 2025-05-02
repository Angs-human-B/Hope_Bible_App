import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hope/utilities/app.constants.dart' show AppConstants;
import '../../widgets/ChatSection/app_bar_header.dart';
import '../../widgets/ChatSection/voice_greeting_box.dart';
import '../../widgets/ChatSection/suggestion_card.dart';
import '../../widgets/ChatSection/chat_input_bar.dart';
import '../../widgets/ChatSection/message_list.dart';
import 'chat/controllers/chat.controller.dart' show ChatController;
import 'dart:async';

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

  // Variables for typing animation
  String _displayedText = '';
  Timer? _typeTimer;
  int _currentIndex = 0;
  bool _isTyping = false;

  late final AnimationController _titleAnimationController;
  // late final Animation<double> _titleFade;

  // Shimmer animation controller
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await chatController.fetchSuggestionsFn();
    });

    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // _titleFade = CurvedAnimation(
    //   parent: _titleAnimationController,
    //   curve: Curves.easeIn,
    // );

    // Initialize shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );
  }

  void _startTypingAnimation(String text) {
    // Cancel any existing timer
    _typeTimer?.cancel();

    setState(() {
      _displayedText = '';
      _currentIndex = 0;
      _isTyping = true;
    });

    // Start typing animation
    _typeTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_currentIndex < text.length) {
        setState(() {
          _displayedText = text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTyping = false;
          // Update the actual message text after typing animation completes
          if (_messages.isNotEmpty) {
            _messages.last = ChatMessage(text: text, isUser: false);
          }
        });
      }
    });
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

    // First create a session if this is the first message
    if (chatController.sessionId.isEmpty) {
      Map<String, dynamic> sessionParams = {
        "userId": AppConstants.userId,
        "title": userText,
      };
      chatController.createSessionFn(sessionParams, context).then((_) {
        // After session is created, send the message
        if (chatController.sessionId.isNotEmpty) {
          chatController.sendMessageFn(userText).then((_) {
            setState(() {
              if (chatController.currentResponse.isNotEmpty) {
                // Add a placeholder message that will be updated with the typing animation
                _messages.add(ChatMessage(text: "", isUser: false));

                // Start the typing animation
                _startTypingAnimation(chatController.currentResponse.value);
              }
              _isGenerating = false;
            });
          });
        }
      });
    } else {
      // If session already exists, just send the message
      chatController.sendMessageFn(userText).then((_) {
        setState(() {
          if (chatController.currentResponse.isNotEmpty) {
            // Add a placeholder message that will be updated with the typing animation
            _messages.add(ChatMessage(text: "", isUser: false));

            // Start the typing animation
            _startTypingAnimation(chatController.currentResponse.value);
          }
          _isGenerating = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _controller.dispose();
    _typeTimer?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0C111D),
      child: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              AppBarHeader(
                title: null,
                // _hasStartedChat
                //     ? FadeTransition(
                //       opacity: _titleFade,
                //       child: const Text(
                //         "Morning Verse",
                //         style: TextStyle(
                //           color: CupertinoColors.white,
                //           fontWeight: FontWeight.w600,
                //           fontSize: 18,
                //         ),
                //       ),
                //     )
                //     : null,
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
                                    VoiceGreetingBox(
                                      userName: AppConstants.name.split(' ')[0],
                                    ),
                                    const Spacer(),
                                    Obx(() {
                                      return chatController
                                                  .isSuggestionLoading
                                                  .value &&
                                              (chatController
                                                  .suggestions
                                                  .isEmpty)
                                          ? const SizedBox()
                                          : SizedBox(
                                            height: 140,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _sendMessage(
                                                      chatController
                                                          .suggestions[0]
                                                          .trim(),
                                                    );
                                                  },
                                                  child: SuggestionCard(
                                                    iconPath:
                                                        'assets/icons/chat_home_1.svg',
                                                    label:
                                                        chatController
                                                            .suggestions[0],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _sendMessage(
                                                      chatController
                                                          .suggestions[1]
                                                          .trim(),
                                                    );
                                                  },
                                                  child: SuggestionCard(
                                                    iconPath:
                                                        'assets/icons/chat_home_2.svg',
                                                    label:
                                                        chatController
                                                            .suggestions[1],
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: () {
                                                    _sendMessage(
                                                      chatController
                                                          .suggestions[2]
                                                          .trim(),
                                                    );
                                                  },
                                                  child: SuggestionCard(
                                                    iconPath:
                                                        'assets/icons/chat_home_3.svg',
                                                    label:
                                                        chatController
                                                            .suggestions[2],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                    }),
                                    const SizedBox(height: 20),
                                  ],
                                )
                                : MessageList(
                                  messages: _messages,
                                  displayedText: _displayedText,
                                  isTyping: _isTyping,
                                  isGenerating: _isGenerating,
                                  shimmerAnimation: _shimmerAnimation,
                                ),
                      ),
                      const SizedBox(height: 10),
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
      ),
    );
  }
}
