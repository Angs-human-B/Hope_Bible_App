import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../media/models/media.model.dart';
import '../favourites/models/favorite.model.dart';
import 'favorites_service.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isMuted = false;
  RxBool isFavorite = false.obs;

  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Stream<Duration> get positionStream => _player.positionStream;

  static Future<void> initBackgroundService() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.hope.audio',
      androidNotificationChannelName: 'Hope Audio',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: true,
    );
  }

  Future<void> init() async {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _player.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });

    _player.durationStream.listen((d) {
      if (d != null) {
        _duration = d;
        debugPrint('Duration updated: $_duration');
        notifyListeners();
      }
    });
  }

  Future<void> setSource(String url, Media media) async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: media.id,
            album: 'Hope',
            title: media.title,
            artUri: Uri.parse(media.thumbnail ?? ''),
          ),
        ),
      );
      final duration = await _player.duration;
      if (duration != null) {
        _duration = duration;
        debugPrint('Total audio duration: $_duration');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading audio source: $e');
    }
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlay() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
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

  // Check if a media is in favorites
  Future<void> checkFavorite(String mediaId) async {
    try {
      final favoritesController = FavoritesController.to;
      final isInFavorites = await favoritesController.checkIsFavorite(mediaId);
      isFavorite.value = isInFavorites;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String mediaId) async {
    try {
      final favoritesController = FavoritesController();
      final success = await favoritesController.toggleFavorite(mediaId);
      if (success) {
        isFavorite.value = !isFavorite.value;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }
}
