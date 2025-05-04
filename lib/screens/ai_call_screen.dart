// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/openai_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class AICallScreen extends StatefulWidget {
  final String userName;

  const AICallScreen({super.key, required this.userName});

  @override
  State<AICallScreen> createState() => _AICallScreenState();
}

class _AICallScreenState extends State<AICallScreen>
    with TickerProviderStateMixin {
  String emphemeralKey = "";
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  RTCDataChannel? dataChannel;
  String currentResponse = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isListening = false;
  bool _isMuted = false;
  bool _isSpeakerOn = true;

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

    // Initialize audio and permissions after animations
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _initializeAudioAndPermissions();
      // Auto-start the call
      _startListening();
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
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      print('Microphone permission denied');
      return;
    }
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
            // ignore: invalid_return_type_for_catch_error
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

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (localStream != null) {
        localStream?.getAudioTracks().forEach((track) {
          track.enabled = !_isMuted;
        });
      }
    });
  }

  void _toggleSpeaker() async {
    try {
      final session = await AudioSession.instance;
      setState(() {
        _isSpeakerOn = !_isSpeakerOn;
      });

      if (_isSpeakerOn) {
        // Enable speaker
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
        await _audioPlayer.setVolume(1.0);
      } else {
        // Disable speaker (use earpiece)
        await session.configure(
          const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionMode: AVAudioSessionMode.spokenAudio,
            avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
            androidAudioAttributes: AndroidAudioAttributes(
              contentType: AndroidAudioContentType.speech,
              usage: AndroidAudioUsage.voiceCommunication,
            ),
          ),
        );
        await _audioPlayer.setVolume(0.5);
      }

      await session.setActive(true);
    } catch (e) {
      print('Error toggling speaker: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            shape: BoxShape.circle,
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _stopListening();
              Navigator.of(context).pop();
            },
            child: const Icon(
              CupertinoIcons.back,
              color: CupertinoColors.white,
              size: 20,
            ),
          ),
        ),
        middle: Text(''),
        backgroundColor: Color(0xFF0C111D),
        border: null,
      ),
      backgroundColor: const Color(0xFF0C111D),
      child: Stack(
        children: [
          // Back Button

          // Greeting Box
          Padding(
            padding: const EdgeInsets.only(bottom: 140),
            child: Center(
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
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 28,
            //     vertical: 16,
            //   ),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF2C2F35),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: RichText(
            //     textAlign: TextAlign.center,
            //     text: TextSpan(
            //       style: const TextStyle(
            //         fontSize: 24,
            //         color: CupertinoColors.white,
            //       ),
            //       children: [
            //         WidgetSpan(
            //           child: AllText(
            //             text: "Hello, ",
            //             style: const TextStyle(
            //               fontSize: 24,
            //               color: CupertinoColors.white,
            //             ),
            //           ),
            //         ),
            //         WidgetSpan(
            //           child: AllText(
            //             text: widget.userName,
            //             style: const TextStyle(
            //               fontSize: 24,
            //               fontWeight: FontWeight.bold,
            //               color: Color(0xFFFFC943),
            //             ),
            //           ),
            //         ),
            //         WidgetSpan(
            //           child: AllText(
            //             text: "\nHow can I help?",
            //             style: const TextStyle(
            //               fontSize: 24,
            //               color: CupertinoColors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),

          // Transcription overlay
          // if (_showTranscription && currentResponse.isNotEmpty)
          //   Positioned(
          //     left: 20,
          //     right: 20,
          //     bottom: 120,
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
          //               color: CupertinoColors.black.withOpacity(0.2),
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
          //                     color: CupertinoColors.systemRed.withOpacity(0.1),
          //                     borderRadius: BorderRadius.circular(6),
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

          // Bottom Buttons
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SvgRoundIcon(
                  'assets/icons/mute.svg',
                  radius: 48,
                  iconColor:
                      _isMuted ? CupertinoColors.black : CupertinoColors.white,
                  background:
                      _isMuted
                          ? CupertinoColors.white
                          : const Color(0xFF444444),
                  onTap: _toggleMute,
                ),
                _SvgRoundIcon(
                  'assets/icons/callcut.svg',
                  radius: 72,
                  background: CupertinoColors.systemRed,
                  iconColor: CupertinoColors.white,
                  size: 32,
                  onTap: () {
                    _stopListening();
                    Navigator.of(context).pop();
                  },
                ),
                _SvgRoundIcon(
                  'assets/icons/soundoff.svg',
                  radius: 48,
                  iconColor:
                      _isSpeakerOn
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                  background:
                      _isSpeakerOn
                          ? const Color(0xFF444444)
                          : CupertinoColors.white,
                  onTap: _toggleSpeaker,
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
      _isConnecting = true;
      currentResponse = 'Initializing connection...';
    });

    try {
      // Ensure any existing connection is properly closed
      await _cleanupConnections();

      emphemeralKey = await OpenAIService.getEphemeralToken();
      print("Key Generated: $emphemeralKey");

      final configs = {
        'iceServers': [
          {
            'urls': [
              'stun:stun1.1.google.com:19302',
              'stun:stun2.1.google.com:19302',
              'stun:stun.l.google.com:19302',
            ],
          },
        ],
        'sdpSemantics': 'unified-plan',
        'enableDtlsSrtp': true,
        'iceCandidatePoolSize': 10,
      };

      peerConnection = await createPeerConnection(configs);
      if (peerConnection == null) {
        throw Exception("Failed to create peer connection");
      }

      // Set up connection state handling
      peerConnection?.onConnectionState = (state) {
        print("Connection state changed to: $state");
        switch (state) {
          case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
            setState(() {
              _isConnected = true;
              _isConnecting = false;
              currentResponse = 'Connected';
            });
            break;
          case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
            print("Connection failed - attempting reconnection...");
            _handleConnectionFailure();
            break;
          case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
            print("Connection disconnected - attempting reconnection...");
            _handleConnectionFailure();
            break;
          default:
            break;
        }
      };

      peerConnection?.onIceCandidate = (candidate) async {
        print("Got ICE Candidate: ${candidate.candidate ?? ""}");
        if (candidate.candidate != null && peerConnection != null) {
          try {
            await peerConnection!.addCandidate(candidate);
          } catch (e) {
            print("Error adding candidate: $e");
            // Don't throw here, just log the error and continue
          }
        }
      };

      peerConnection?.onIceConnectionState = (state) {
        print("ICE Connection State: $state");
        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          _handleConnectionFailure();
        }
      };

      // Only get microphone access for sending audio, not receiving
      final mediaConfigs = {
        'audio': true,
        'video': false,
        'audioReceive': false,
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
        'offerToReceiveAudio': false,
        'offerToReceiveVideo': false,
        'voiceActivityDetection': true,
        'iceRestart': true,
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
      }
    } catch (e) {
      print('Error in startWebRtcSession: $e');
      _handleConnectionFailure();
    }
  }

  void _handleConnectionFailure() async {
    if (!mounted) return;

    setState(() {
      _isConnecting = false;
      _isConnected = false;
      currentResponse = 'Connection issue detected. Reconnecting...';
    });

    // Wait a bit before attempting reconnection
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Only attempt reconnection if we're still listening
    if (_isListening) {
      print("Attempting to reconnect...");
      await startWebRtcSession();
    }
  }

  void setupDataChannel() {
    dataChannel?.onMessage = (message) {
      if (!mounted) return;

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

    dataChannel?.onDataChannelState = (state) {
      print("DataChannel State: $state");
      if (state == RTCDataChannelState.RTCDataChannelClosed ||
          state == RTCDataChannelState.RTCDataChannelClosing) {
        _handleConnectionFailure();
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
        dataChannel?.onMessage = null;
        dataChannel?.onDataChannelState = null;
        await dataChannel?.close();
        dataChannel = null;
      }

      if (localStream != null) {
        print("Stopping local stream tracks...");
        localStream?.getTracks().forEach((track) async {
          await track.stop();
          await track.dispose();
        });
        await localStream?.dispose();
        localStream = null;
      }

      if (peerConnection != null) {
        print("Closing peer connection...");
        final senders = await peerConnection?.getSenders();
        if (senders != null) {
          for (var sender in senders) {
            await peerConnection?.removeTrack(sender);
          }
        }

        peerConnection?.onIceCandidate = null;
        peerConnection?.onConnectionState = null;
        peerConnection?.onIceConnectionState = null;
        peerConnection?.onTrack = null;

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
    _typeTimer?.cancel();
    _textFadeController.dispose();
    _fadeController.dispose();
    print("Disposing AICallScreen...");
    _audioPlayer.dispose();
    stopWebRtcConnection();
    super.dispose();
  }
}

class _SvgRoundIcon extends StatelessWidget {
  final String assetPath;
  final double radius;
  final Color background;
  final Color iconColor;
  final double size;
  final VoidCallback? onTap;

  const _SvgRoundIcon(
    this.assetPath, {
    this.radius = 60,
    this.background = const Color(0xFF444444),
    this.iconColor = CupertinoColors.white,
    this.size = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
