import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isMuted = false;

  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Stream<Duration> get positionStream => _player.onPositionChanged;

  Future<void> init() async {
    // Load audio asset
    await _player.setSource(AssetSource('audio/sample.mp3'));
    final total = await _player.getDuration();
    if (total != null) {
      _duration = total;
      debugPrint('Total audio duration: $_duration');
      notifyListeners();
    }

    // Listen for any duration changes as fallback
    _player.onDurationChanged.listen((d) {
      _duration = d;
      debugPrint('Duration updated: $_duration');
      notifyListeners();
    });

    _player.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _player.setVolume(_isMuted ? 0.0 : 1.0);
    notifyListeners();
  }

  void seek(Duration pos) {
    _player.seek(pos);
  }

  void next() {}

  void previous() {}

  void save() {}

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
