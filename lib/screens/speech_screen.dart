// ignore_for_file: unused_field

import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart'
    show StreamAudioResponse, StreamAudioSource;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/openai_service.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final OpenAIService _openAIService = OpenAIService();
  bool _isListening = false;
  String _transcript = '';
  bool _isProcessing = false;
  String _errorMessage = '';
  bool _isInitialized = false;
  String _assistantResponse = '';
  List<Uint8List> _audioChunks = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize speech recognition first
      final available = await _speechToText.initialize();

      if (available) {
        // Request microphone permission
        final status = await Permission.microphone.request();

        if (status.isGranted) {
          // Initialize OpenAI after speech recognition is ready
          await _openAIService.initialize();

          // Set up response update callback
          _openAIService.onResponseUpdate = (response) {
            setState(() {
              _assistantResponse = response;
            });
          };

          setState(() {
            _isInitialized = true;
            _errorMessage = '';
          });
        } else {
          await _openAIService.initialize();
          setState(() {
            _errorMessage =
                'Microphone permission is required for speech recognition';
            _isInitialized = true;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Speech recognition is not available on this device';
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize services: $e';
        _isInitialized = true;
      });
    }
  }

  Future<void> _startListening() async {
    if (!_isListening && _isInitialized) {
      try {
        final available = await _speechToText.initialize();
        if (available) {
          setState(() {
            _isListening = true;
            _errorMessage = '';
            _assistantResponse = ''; // Clear previous response
            _audioChunks = []; // Clear previous audio chunks
          });

          await _speechToText.listen(
            onResult: (result) {
              setState(() {
                _transcript = result.recognizedWords;
              });
            },
            listenFor: const Duration(minutes: 30),
            // pauseFor: const Duration(seconds: 3),
            partialResults: true,
            onSoundLevelChange: (level) {},
          );
        } else {
          setState(() {
            _errorMessage = 'Speech recognition is not available';
            _isInitialized = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to start speech recognition: $e';
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);

      if (_transcript.isNotEmpty) {
        await _sendToOpenAI();
      }
    }
  }

  Future<void> _sendToOpenAI() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = '';
      _assistantResponse = ''; // Clear previous response
    });

    try {
      print('Sending message to OpenAI: $_transcript');
      await _openAIService.sendMessage(_transcript);
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message to OpenAI: $e');
      setState(() {
        _errorMessage = 'Failed to send message: $e';
      });
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _openAIService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Speech to Speech'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: CupertinoColors.destructiveRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Your message:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _transcript.isEmpty
                          ? 'Your speech will appear here'
                          : _transcript,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (_assistantResponse.isNotEmpty) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Assistant response:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _assistantResponse,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_isProcessing)
                const CupertinoActivityIndicator()
              else
                CupertinoButton(
                  onPressed:
                      _isInitialized
                          ? () async {
                            if (_isListening) {
                              await _stopListening();
                            } else {
                              await _startListening();
                            }
                          }
                          : null,
                  child: Text(
                    _isListening ? 'Stop Listening' : 'Start Listening',
                  ),
                ),
              if (!_isInitialized)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Initializing...',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey.resolveFrom(context),
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

class BytesSource extends StreamAudioSource {
  final Uint8List bytes;
  BytesSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
