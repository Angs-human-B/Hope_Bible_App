import 'dart:async' show StreamSubscription;
import 'dart:convert';
import 'dart:math' as math;
import 'package:openai_realtime_dart/openai_realtime_dart.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import '../config/api_config.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final RealtimeClient _client = RealtimeClient(
    apiKey: ApiConfig.openAiApiKey,
    dangerouslyAllowAPIKeyInBrowser: true,
  );
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _currentResponse = '';
  Function(String)? onResponseUpdate;
  bool _isConnected = false;
  bool _isPlaying = false;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final List<Uint8List> _audioQueue = [];
  bool _isProcessingQueue = false;
  bool _isResponseComplete = false;
  int _chunkCounter = 0;

  static const String baseUrl = 'https://api.openai.com/v1';
  static const String apiKey =
      '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';

  String get currentResponse => _currentResponse;

  Future<void> initialize() async {
    try {
      print('Initializing OpenAI client...');

      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionMode: AVAudioSessionMode.spokenAudio,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.longFormAudio,
          avAudioSessionSetActiveOptions:
              AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        ),
      );

      // Activate audio session
      await session.setActive(true);

      // Initialize audio player with maximum volume
      await _audioPlayer.setVolume(1.0);

      // Set up player state subscription
      _playerStateSubscription?.cancel();
      _playerStateSubscription = _audioPlayer.playerStateStream.listen(
        (state) {
          print(
            'Audio state: ${state.processingState}, playing: ${state.playing}',
          );
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            if (_isResponseComplete && _audioQueue.isEmpty) {
              print('All audio playback completed');
            } else {
              _processNextAudioChunk();
            }
          }
        },
        onError: (error) {
          print('Audio player error: $error');
          _isPlaying = false;
          _processNextAudioChunk();
        },
      );

      // Set up event handling
      _client.on(RealtimeEventType.responseAudioDelta, (event) {
        print('=== START AUDIO DELTA PROCESSING ===');
        print('Received responseAudioDelta event - processing now');
        try {
          final audioEvent = event as RealtimeEventResponseAudioDelta;
          if (audioEvent.delta.isEmpty) {
            print('Warning: Received empty delta');
            return;
          }

          print('Delta length: ${audioEvent.delta.length}');
          print(
            'First 50 chars of delta: ${audioEvent.delta.substring(0, math.min(50, audioEvent.delta.length))}',
          );

          // Verify if the delta is valid base64
          if (!_isBase64(audioEvent.delta)) {
            print('Warning: Received delta is not valid base64');
            return;
          }

          final audioData = base64Decode(audioEvent.delta);
          print('Successfully decoded base64 to audio data');
          print('Audio data length: ${audioData.length} bytes');

          _audioQueue.add(audioData);
          print(
            'Added audio data to queue. Current queue length: ${_audioQueue.length}',
          );

          if (!_isPlaying) {
            print('Not currently playing, will process next chunk');
            _processNextAudioChunk();
          } else {
            print('Currently playing, chunk queued for later');
          }
        } catch (e, stackTrace) {
          print('Error processing audio delta:');
          print('Error details: $e');
          print('Stack trace: $stackTrace');
        } finally {
          print('=== END AUDIO DELTA PROCESSING ===');
        }
      });

      _client.on(RealtimeEventType.conversationUpdated, (event) {
        final result = (event as RealtimeEventConversationUpdated).result;
        final delta = result.delta;
        final item = result.item;

        if (delta?.transcript != null) {
          _currentResponse += delta!.transcript!;
          print('Received transcript: ${delta.transcript}');
          onResponseUpdate?.call(_currentResponse);
        }

        if (item?.item is ItemMessage) {
          final message = item!.item as ItemMessage;
          if (message.role == ItemRole.assistant) {
            final content = message.content.firstOrNull;
            if (content is ContentPartText) {
              _currentResponse = content.text;
              print('Assistant message: $_currentResponse');
              onResponseUpdate?.call(_currentResponse);
            }
          }
        }
      });

      _client.on(RealtimeEventType.error, (event) {
        print('Received error event: ${(event as RealtimeEventError).error}');
      });

      _client.on(RealtimeEventType.conversationInterrupted, (event) {
        print('Conversation interrupted');
        _stopAudio();
      });

      _client.on(RealtimeEventType.responseAudioDone, (event) {
        print('Response audio completed');
        _isResponseComplete = true;
      });

      // Configure the session
      await _client.updateSession(
        instructions:
            '''You are a Christian AI assistant focused on providing biblical guidance and Christian teachings. Your responses should:

1. Always align with traditional Christian doctrine and biblical principles
2. Base responses on Scripture, citing relevant Bible verses when appropriate
3. Maintain a respectful and reverent tone when discussing spiritual matters
4. Focus on Christian values, morals, and ethical teachings
5. Avoid any content that contradicts Christian beliefs or promotes non-Christian ideologies
6. When discussing theological topics, stick to widely accepted Christian interpretations
7. Emphasize love, grace, and forgiveness as core Christian values
8. Be clear that you are an AI tool meant to assist with Christian guidance, not replace human spiritual leadership
9. Avoid making definitive theological statements about controversial topics
10. Always maintain a tone of humility and reverence when discussing spiritual matters

You are not a replacement for pastoral guidance or personal spiritual discernment. Your role is to assist with biblical knowledge and Christian teachings while encouraging users to seek proper spiritual guidance from their church leaders.''',
        voice: Voice.alloy,
        turnDetection: TurnDetection(type: TurnDetectionType.serverVad),
        inputAudioTranscription: InputAudioTranscriptionConfig(
          model: 'whisper-1',
        ),
      );

      print('Connecting to OpenAI...');
      await _client.connect();
      _isConnected = true;
      print('OpenAI client connected successfully');
    } catch (e) {
      print('Error initializing OpenAI client: $e');
      rethrow;
    }
  }

  Future<void> _processNextAudioChunk() async {
    if (_isProcessingQueue || _isPlaying || _audioQueue.isEmpty) {
      return;
    }

    try {
      _isProcessingQueue = true;
      final audioData = _audioQueue.removeAt(0);

      print('Processing audio chunk of size: ${audioData.length} bytes');

      // Save audio chunk to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/chunk_${_chunkCounter++}.mp3');
      await file.writeAsBytes(audioData);
      print('Saved audio chunk to: ${file.path}');

      // Reset player state
      await _audioPlayer.stop();
      _isPlaying = true;

      // Set up audio source and play
      await _audioPlayer.setFilePath(file.path);
      await _audioPlayer.setVolume(1.0);

      // Wait for audio to be ready
      await _audioPlayer.load();
      final duration = await _audioPlayer.duration;
      print('Audio loaded, duration: ${duration?.inMilliseconds ?? 0}ms');

      // Start playback
      await _audioPlayer.play();
      print('Started playing audio file');

      // Wait for playback to complete
      await _audioPlayer.processingStateStream.firstWhere(
        (state) => state == ProcessingState.completed,
      );

      print('Finished playing audio chunk');
      _isPlaying = false;

      // Clean up temporary file
      await file.delete();
    } catch (e) {
      print('Error processing audio chunk: $e');
      _isPlaying = false;
    } finally {
      _isProcessingQueue = false;
      if (!_isPlaying && _audioQueue.isNotEmpty) {
        _processNextAudioChunk();
      }
    }
  }

  Future<void> _stopAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        _isPlaying = false;
        _audioQueue.clear();
        _isResponseComplete = false;
        print('Audio playback stopped');
      }
    } catch (e) {
      print('Error stopping audio: $e');
      _isPlaying = false;
    }
  }

  Future<void> sendMessage(String text) async {
    if (!_isConnected) {
      print('Client not connected, attempting to reconnect...');
      await initialize();
    }

    try {
      _currentResponse = '';
      _isResponseComplete = false;
      _chunkCounter = 0;
      await _stopAudio();

      print('Sending message to OpenAI: $text');
      final result = await _client.sendUserMessageContent([
        ContentPart.inputText(text: text),
      ]);
      print('Message sent successfully. Result: $result');
    } catch (e) {
      print('Error sending message to OpenAI: $e');
      rethrow;
    }
  }

  Future<void> appendAudio(Uint8List audioData) async {
    if (!_isConnected) {
      print('Client not connected, attempting to reconnect...');
      await initialize();
    }

    try {
      print('Appending audio data: ${audioData.length} bytes');
      await _client.appendInputAudio(audioData);
      print('Creating response...');
      await _client.createResponse();
    } catch (e) {
      print('Error appending audio: $e');
      rethrow;
    }
  }

  void dispose() {
    _playerStateSubscription?.cancel();
    _stopAudio();
    _audioPlayer.dispose();
    _client.disconnect();
    _isConnected = false;
  }

  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getEphemeralToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/realtime/sessions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'instructions':
              '''You are a Christian AI assistant focused on providing biblical guidance and Christian teachings. Your responses should:

1. Always align with traditional Christian doctrine and biblical principles
2. Base responses on Scripture, citing relevant Bible verses when appropriate
3. Maintain a respectful and reverent tone when discussing spiritual matters
4. Focus on Christian values, morals, and ethical teachings
5. Avoid any content that contradicts Christian beliefs or promotes non-Christian ideologies
6. When discussing theological topics, stick to widely accepted Christian interpretations
7. Emphasize love, grace, and forgiveness as core Christian values
8. Be clear that you are an AI tool meant to assist with Christian guidance, not replace human spiritual leadership
9. Avoid making definitive theological statements about controversial topics
10. Always maintain a tone of humility and reverence when discussing spiritual matters

You are not a replacement for pastoral guidance or personal spiritual discernment. Your role is to assist with biblical knowledge and Christian teachings while encouraging users to seek proper spiritual guidance from their church leaders.''',
          'model': 'gpt-4o-realtime-preview-2024-12-17',
          'voice': 'verse',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['client_secret']['value'];
      } else {
        throw Exception(
          'Failed to get ephemeral token: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting ephemeral token: $e');
    }
  }
}

class BytesSource extends StreamAudioSource {
  final Uint8List bytes;
  BytesSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    print(
      'Creating audio stream with format: audio/mpeg, size: ${end - start} bytes',
    );
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
