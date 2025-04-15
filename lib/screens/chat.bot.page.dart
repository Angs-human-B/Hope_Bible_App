// ignore_for_file: unused_field, avoid_print, invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/openai_service.dart';
import 'dart:async';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage>
    with TickerProviderStateMixin {
  String emphemeralKey = "";
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  RTCDataChannel? dataChannel;
  String currentResponse = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isListening = false;

  // Add connection state tracking
  bool _isConnecting = false;
  bool _isConnected = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Add new controllers for text animation
  late AnimationController _textFadeController;
  late Animation<double> _textFadeAnimation;
  String _previousResponse = '';
  bool _showTranscription = false;

  // Add variables for typing animation
  String _displayedText = '';
  Timer? _typeTimer;
  int _currentIndex = 0;

  // Add animation controllers for connection state
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _statusFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers first
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _statusFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start pulse animation when connecting
    _pulseController.repeat(reverse: true);

    // Initialize audio and permissions after animations
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _initializeAudioAndPermissions();
    });
  }

  Future<void> _initializeAudioAndPermissions() async {
    try {
      // Request permissions first
      await requestPermissions();

      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
          avAudioSessionMode: AVAudioSessionMode.spokenAudio,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.defaultToSpeaker,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.speech,
            usage: AndroidAudioUsage.media,
          ),
        ),
      );

      // Activate audio session
      await session.setActive(true);

      // Set up audio player
      await _audioPlayer.setVolume(1.0);

      // Set up audio player state listener
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> _cleanupConnections() async {
    if (_isConnecting || _isConnected) {
      await stopWebRtcConnection();
    }
  }

  Future<void> requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> _playAudioData(Uint8List audioData) async {
    if (_isPlaying) {
      print('Already playing audio, skipping...');
      return;
    }

    try {
      setState(() {
        _isPlaying = true;
      });

      // Save audio data to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
      );
      await tempFile.writeAsBytes(audioData);

      // Play the audio file
      await _audioPlayer.setFilePath(tempFile.path);
      await _audioPlayer.play();

      // Delete the temporary file after playback
      _audioPlayer.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          tempFile.delete().catchError(
            (e) => print('Error deleting temp file: $e'),
          );
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _startListening() async {
    setState(() => _isListening = true);
    _fadeController.forward();
    setState(() {
      _isConnecting = true;
    });
    await startWebRtcSession();
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
      _showTranscription = false;
    });
    _fadeController.reverse();
    await stopWebRtcConnection();
  }

  // Add method to handle response updates
  void _updateResponse(String newResponse) {
    if (newResponse != _previousResponse) {
      setState(() {
        _previousResponse = currentResponse;
        currentResponse = newResponse;
        _showTranscription = true;
        // Reset typing animation
        _displayedText = '';
        _currentIndex = 0;
      });
      _textFadeController.reset();
      _textFadeController.forward();

      // Cancel existing timer if any
      _typeTimer?.cancel();

      // Start typing animation
      _typeTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        if (_currentIndex < currentResponse.length) {
          setState(() {
            _displayedText = currentResponse.substring(0, _currentIndex + 1);
            _currentIndex++;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  Widget _buildStatusIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Animated status dot
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _isConnecting ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _isConnected
                            ? CupertinoColors.activeGreen
                            : _isConnecting
                            ? CupertinoColors.systemOrange
                            : CupertinoColors.systemRed,
                    boxShadow: [
                      BoxShadow(
                        color: (_isConnected
                                ? CupertinoColors.activeGreen
                                : _isConnecting
                                ? CupertinoColors.systemOrange
                                : CupertinoColors.systemRed)
                            .withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: _isConnecting ? 2 : 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // Animated status text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _isConnected
                  ? 'Ready'
                  : _isConnecting
                  ? 'Connecting...'
                  : 'Tap to speak',
              key: ValueKey<String>(
                _isConnected
                    ? 'ready'
                    : _isConnecting
                    ? 'connecting'
                    : 'tap',
              ),
              style: TextStyle(
                color: CupertinoColors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              _isListening
                  ? CupertinoColors.systemRed
                  : _isConnecting
                  ? const Color(0xFF2C2C2E)
                  : const Color(0xFF2C2C2E),
          boxShadow: [
            BoxShadow(
              color:
                  _isListening
                      ? CupertinoColors.systemRed.withOpacity(0.3)
                      : _isConnecting
                      ? CupertinoColors.systemOrange.withOpacity(0.3)
                      : CupertinoColors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: _isListening || _isConnecting ? 4 : 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Connection loading indicator
            if (_isConnecting)
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _pulseController.value * 2 * 3.14159,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CupertinoColors.systemOrange.withOpacity(0.5),
                          width: 2,
                        ),
                        gradient: SweepGradient(
                          colors: [
                            CupertinoColors.systemOrange.withOpacity(0.8),
                            CupertinoColors.systemOrange.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            // Mic icon
            Icon(
              _isListening ? CupertinoIcons.xmark : CupertinoIcons.mic,
              color:
                  _isConnecting
                      ? CupertinoColors.systemOrange
                      : CupertinoColors.white,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  const Color(0xFF1A1A1A).withOpacity(0.8),
                  CupertinoColors.black,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Status bar with new animated indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(children: [_buildStatusIndicator()]),
                ),

                // Main content area
                Expanded(
                  child: Stack(
                    children: [
                      // Transcription overlay
                      // if (_showTranscription && currentResponse.isNotEmpty)
                      //   Positioned(
                      //     left: 20,
                      //     right: 20,
                      //     bottom: 30,
                      //     child: FadeTransition(
                      //       opacity: _textFadeAnimation,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(20),
                      //         decoration: BoxDecoration(
                      //           color: CupertinoColors.black.withOpacity(0.7),
                      //           borderRadius: BorderRadius.circular(16),
                      //           border: Border.all(
                      //             color: CupertinoColors.white.withOpacity(0.1),
                      //           ),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: CupertinoColors.black.withOpacity(
                      //                 0.2,
                      //               ),
                      //               blurRadius: 20,
                      //               spreadRadius: 5,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 Container(
                      //                   padding: const EdgeInsets.symmetric(
                      //                     horizontal: 8,
                      //                     vertical: 4,
                      //                   ),
                      //                   decoration: BoxDecoration(
                      //                     color: CupertinoColors.systemRed
                      //                         .withOpacity(0.1),
                      //                     borderRadius: BorderRadius.circular(
                      //                       6,
                      //                     ),
                      //                   ),
                      //                   child: Text(
                      //                     'Assistant',
                      //                     style: TextStyle(
                      //                       color: CupertinoColors.systemRed,
                      //                       fontSize: 12,
                      //                       fontWeight: FontWeight.w600,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 12),
                      //             Text(
                      //               _displayedText,
                      //               style: const TextStyle(
                      //                 color: CupertinoColors.white,
                      //                 fontSize: 16,
                      //                 height: 1.5,
                      //                 letterSpacing: 0.3,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),

                      // Centered Lottie animation
                      Center(
                        child: Container(
                          // width: 280,
                          // height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: const Color(0xFF1A1A1A),
                            boxShadow: [
                              if (_isListening)
                                BoxShadow(
                                  color: (_isListening
                                          ? CupertinoColors.activeBlue
                                          : CupertinoColors.activeGreen)
                                      .withOpacity(0.35),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              if (_isListening)
                                BoxShadow(
                                  color: (_isListening
                                          ? CupertinoColors.activeGreen
                                          : CupertinoColors.activeGreen)
                                      .withOpacity(0.25),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background glow
                              // if (_isListening)
                              // Container(
                              //   width: 260,
                              //   height: 260,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     gradient: RadialGradient(
                              //       colors: [
                              //         CupertinoColors.systemRed.withOpacity(
                              //           0.2,
                              //         ),
                              //         CupertinoColors.black.withOpacity(0),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Lottie animation
                              ClipRRect(
                                borderRadius: BorderRadius.circular(140),
                                child: Lottie.asset(
                                  'assets/animations/chatBlob.json',
                                  width: 260,
                                  height: 260,
                                  // fit: BoxFit.cover,
                                  animate: _isListening,
                                  repeat: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom mic button with new loading state
                Container(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _buildMicButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startWebRtcSession() async {
    setState(() {
      _isConnected = false;
    });

    try {
      // Ensure any existing connection is properly closed
      await _cleanupConnections();

      setState(() {
        currentResponse = 'Initializing connection...';
      });

      emphemeralKey = await OpenAIService.getEphemeralToken();
      print("Key Generated: $emphemeralKey");

      final configs = {
        'iceServers': [
          {
            'urls': [
              'stun:stun1.1.google.com:19302',
              'stun:stun2.1.google.com:19302',
            ],
          },
        ],
        'sdpSemantics': 'unified-plan',
        'enableDtlsSrtp': true,
      };

      peerConnection = await createPeerConnection(configs);
      if (peerConnection == null) {
        throw Exception("Failed to create peer connection");
      }

      peerConnection?.onIceCandidate = (candidate) async {
        print("Got ICE Candidate: ${candidate.candidate ?? ""}");
        if (candidate.candidate != null && peerConnection != null) {
          try {
            await peerConnection!.addCandidate(candidate);
          } catch (e) {
            print("Error adding candidate: $e");
          }
        }
      };

      peerConnection?.onConnectionState = (state) {
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
            state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
          stopWebRtcConnection();
        }
      };

      // Only get microphone access for sending audio, not receiving
      final mediaConfigs = {
        'audio': true,
        'video': false,
        'audioReceive': false, // Disable receiving audio from WebRTC
      };

      localStream = await navigator.mediaDevices.getUserMedia(mediaConfigs);
      if (peerConnection != null &&
          peerConnection?.connectionState !=
              RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        localStream?.getTracks().forEach((track) {
          track.enableSpeakerphone(true);
          peerConnection?.addTrack(track, localStream!);
        });
      }

      RTCDataChannelInit dataChannelInit =
          RTCDataChannelInit()
            ..ordered = true
            ..maxRetransmits = 30
            ..protocol = 'sctp'
            ..negotiated = false;

      dataChannel = await peerConnection?.createDataChannel(
        "oai-events",
        dataChannelInit,
      );
      if (dataChannel != null) {
        setupDataChannel();
      }

      final offerOptions = {
        'offerToReceiveAudio': false, // Disable receiving audio in offer
        'offerToReceiveVideo': false,
        'voiceActivityDetection': true,
      };

      RTCSessionDescription? offer = await peerConnection?.createOffer(
        offerOptions,
      );
      await peerConnection?.setLocalDescription(offer!);

      const baseUrl = 'https://api.openai.com/v1/realtime';
      const model = 'gpt-4o-realtime-preview-2024-12-17';

      var request = http.Request('POST', Uri.parse('$baseUrl?model=$model'));
      request.body = offer?.sdp?.replaceAll('\r\n', '\n') ?? '';
      request.headers.addAll({
        'Authorization': 'Bearer $emphemeralKey',
        'Content-Type': 'application/sdp',
        'Accept': 'application/sdp',
      });

      final response = await http.Client().send(request);
      String sdpResponse = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to get SDP answer: ${response.statusCode}');
      }

      if (peerConnection != null &&
          peerConnection?.connectionState !=
              RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        final answer = RTCSessionDescription(sdpResponse, 'answer');
        await peerConnection?.setRemoteDescription(answer);
        print('WebRTC connection established');

        peerConnection?.onConnectionState = (state) async {
          print('Connection State: $state');
          setState(() {
            currentResponse = 'Connection State: $state';
          });
        };
      }

      // Update connection state when connected
      setState(() {
        _isConnected = true;
      });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _isConnected = false;
        currentResponse = 'Error: $e';
      });
      print('Error in startWebRtcSession: $e');
    }
  }

  void setupDataChannel() {
    dataChannel?.onMessage = (message) {
      try {
        final data = json.decode(message.text);
        print('\n==================== OpenAI Response ====================');
        print('Raw response data: $data');

        if (data['type'] == 'conversation.item.text') {
          _updateResponse(data['text']);
        } else if (data['type'] == "response.audio_transcript.done") {
          _updateResponse(data['transcript']);
        } else if (data['type'] == 'response.audio_delta') {
          try {
            final audioData = base64Decode(data['audio']);
            _playAudioData(audioData);
          } catch (e) {
            print('Error processing audio data: $e');
          }
        }
        print('======================================================\n');
      } catch (e) {
        print('Error processing OpenAI message: $e');
      }
    };
  }

  Future<void> stopWebRtcConnection() async {
    if (!_isConnecting && !_isConnected) {
      return; // Already cleaned up
    }

    setState(() {
      _isConnecting = false;
      _isConnected = false;
    });

    print("Stopping WebRTC connection...");
    try {
      // Stop audio playback
      if (_isPlaying) {
        await _audioPlayer.stop();
        _isPlaying = false;
      }

      if (dataChannel != null) {
        print("Closing data channel...");
        dataChannel?.onMessage = null; // Remove message handler
        await dataChannel?.close();
        dataChannel = null;
      }

      if (localStream != null) {
        print("Stopping local stream tracks...");
        localStream?.getTracks().forEach((track) {
          track.stop();
          track.dispose();
        });
        await localStream?.dispose();
        localStream = null;
      }

      if (peerConnection != null) {
        print("Closing peer connection...");
        // Remove all tracks and close all connections
        final senders = await peerConnection?.getSenders();
        if (senders != null) {
          for (var sender in senders) {
            await peerConnection?.removeTrack(sender);
          }
        }

        // Remove all event handlers
        peerConnection?.onIceCandidate = null;
        peerConnection?.onConnectionState = null;
        peerConnection?.onTrack = null;

        // Close the peer connection
        await peerConnection?.close();
        await peerConnection?.dispose();
        peerConnection = null;
      }

      setState(() {
        currentResponse = 'Connection terminated';
        emphemeralKey = "";
      });
      print("WebRTC Connection terminated successfully");
    } catch (e) {
      print("Error during connection cleanup: $e");
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _typeTimer?.cancel();
    _textFadeController.dispose();
    _fadeController.dispose();
    print("Disposing MainScreen...");
    _audioPlayer.dispose();
    stopWebRtcConnection(); // Use stopWebRtcConnection instead of _cleanupConnections
    super.dispose();
  }
}
