import 'dart:ui';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' show ProcessingState;

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../services/audio_service.dart';
import '../../services/favorites_service.dart' show FavoritesController;
import '../../widgets/AudioPlayer/achievement_popup.dart';
import '../../widgets/AudioPlayer/audio_controls.dart';
import '../../widgets/AudioPlayer/audio_slider.dart';
import '../../media/models/media.model.dart' show Media;

class AudioPlayerScreen extends StatefulWidget {
  final Media media;
  final List<Media> mediaList;
  final int currentIndex;

  const AudioPlayerScreen({
    super.key,
    required this.media,
    required this.mediaList,
    required this.currentIndex,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  final favouritesController = Get.find<FavoritesController>();
  final AudioService _audio = AudioService();
  late final PageController _pageController;
  bool _isLyricsShown = false;
  int _currentSubtitleIndex = 0;
  late int _currentMediaIndex;
  late Media _currentMedia;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  bool _showGoalPopup = false;
  double _dragStartX = 0;
  double _currentDragX = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentMediaIndex = widget.currentIndex;
    _currentMedia = widget.media;
    _pageController = PageController();
    _audio.init();
    _initAudio();
    _checkFavoriteStatus();

    // Set up position stream subscription
    _positionSubscription = _audio.positionStream.listen((position) {
      if (mounted) {
        _updateCurrentSubtitle(position);
        // Force UI update for slider
        setState(() {});
      }
    });

    // Set up player state stream subscription
    _playerStateSubscription = _audio.playerStateStream.listen((playerState) {
      print(
        'Player State: ${playerState.processingState}, Playing: ${playerState.playing}',
      );

      if (mounted) {
        setState(() {
          // Update play/pause state
          if (playerState.processingState != ProcessingState.completed) {
            // Only update playing state if not completed
            _audio.updatePlayingState(playerState.playing);
          }
        });
      }

      // Check if the current track has completed
      if (playerState.processingState == ProcessingState.completed) {
        if (mounted) {
          _playNext();
        }
        print('Track completed, attempting to play next');
      }
    });
  }

  void _updateCurrentSubtitle(Duration position) {
    if (_currentMedia.subtitleInfo == null ||
        _currentMedia.subtitleInfo!.isEmpty) {
      return;
    }

    setState(() {
      // Find the appropriate subtitle for the current position
      for (int i = 0; i < _currentMedia.subtitleInfo!.length; i++) {
        final timecode = _currentMedia.subtitleInfo![i].timecode;
        final minutes = int.parse(timecode.split(':')[0]);
        final seconds = int.parse(timecode.split(':')[1]);
        final subtitlePosition = Duration(minutes: minutes, seconds: seconds);

        if (position < subtitlePosition) {
          _currentSubtitleIndex = (i - 1).clamp(
            0,
            _currentMedia.subtitleInfo!.length - 1,
          );
          return;
        }
      }
      _currentSubtitleIndex = _currentMedia.subtitleInfo!.length - 1;
    });
  }

  Future<void> _initAudio() async {
    if (_currentMedia.signedUrl != null) {
      try {
        await _audio.setSource(_currentMedia.signedUrl!, _currentMedia);
        // Force a rebuild after audio is initialized
        if (mounted) setState(() {});
      } catch (e) {
        print('Error initializing audio: $e');
      }
    }
  }

  Future<void> _checkFavoriteStatus() async {
    await _audio.checkFavorite(_currentMedia.id);
  }

  void _playNext() async {
    if (_currentMediaIndex < widget.mediaList.length - 1) {
      setState(() {
        _currentMediaIndex++;
        _currentMedia = widget.mediaList[_currentMediaIndex];
      });
      // Wait for audio to be initialized
      await _initAudio();
      // Update state again after audio is initialized
      setState(() {});
    }
  }

  void _playPrevious() async {
    if (_currentMediaIndex > 0) {
      setState(() {
        _currentMediaIndex--;
        _currentMedia = widget.mediaList[_currentMediaIndex];
      });
      await _initAudio();
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audio.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _isLyricsShown = (page == 1));
  }

  void _togglePage() {
    final newPage = _isLyricsShown ? 0 : 1;
    HapticFeedback.mediumImpact();
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleDragStart(DragStartDetails details) {
    if (_isLyricsShown) return;
    _dragStartX = details.globalPosition.dx;
    _currentDragX = 0;
    _isDragging = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isLyricsShown) return;

    final dragDistance = details.globalPosition.dx - _dragStartX;
    final screenWidth = MediaQuery.of(context).size.width;

    // Limit the drag to 0.5 of the screen width
    _currentDragX = dragDistance.clamp(-screenWidth * 0.5, screenWidth * 0.5);
    setState(() {});
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isLyricsShown) return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = _currentDragX / screenWidth;

    if (dragPercentage.abs() > 0.2 || velocity.abs() > 500) {
      if (dragPercentage > 0 || velocity > 0) {
        _playPrevious();
      } else {
        _playNext();
      }
    }

    _currentDragX = 0;
    _isDragging = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final position = _audio.position;
    final duration = _audio.duration;
    final safeDuration =
        duration.inMilliseconds == 0
            ? const Duration(milliseconds: 1)
            : duration;

    return CupertinoPageScaffold(
      child: GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: Stack(
          children: [
            // blurred background
            Positioned.fill(
              child: Image.network(
                _currentMedia.thumbnail ?? '',
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Image.asset(
                      'assets/images/the_ark.png',
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: CupertinoColors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pop(context);
                          },
                          child: _buildBlurButton(icon: arrowLeft),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _showGoalPopup = true);
                            HapticFeedback.heavyImpact();
                          },
                          child: Text(
                            _currentMedia.title,
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            if (!favouritesController.isFavorite(
                              _currentMedia.id,
                            )) {
                              await favouritesController.toggleFavorite(
                                _currentMedia.id,
                                mediaData: _currentMedia,
                              );
                            } else {
                              await favouritesController.toggleFavorite(
                                _currentMedia.id,
                                mediaData: _currentMedia,
                              );
                            }
                          },
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Container(
                                width: 42.w,
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Obx(() {
                                    final isFavorite = favouritesController
                                        .isFavorite(_currentMedia.id);
                                    return Icon(
                                      isFavorite
                                          ? CupertinoIcons.bookmark_fill
                                          : CupertinoIcons.bookmark,
                                      color: CupertinoColors.white,
                                      size: 20.0,
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(_currentDragX, 0),
                        child: Opacity(
                          opacity:
                              1 -
                              (_currentDragX.abs() /
                                  (MediaQuery.of(context).size.width * 0.5)),
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: _onPageChanged,
                            children: [
                              // Page 0: Book art
                              Center(
                                child: Container(
                                  width: 240.w,
                                  height: 240.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        _currentMedia.thumbnail ?? '',
                                      ),
                                      fit: BoxFit.cover,
                                      onError:
                                          (_, __) => const AssetImage(
                                            'assets/images/the_ark.png',
                                          ),
                                    ),
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                ),
                              ),
                              // Page 1: Subtitles list
                              if (_currentMedia.subtitleInfo != null)
                                ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  itemCount: _currentMedia.subtitleInfo!.length,
                                  itemBuilder: (context, index) {
                                    final subtitle =
                                        _currentMedia.subtitleInfo![index];
                                    final isCurrent =
                                        index == _currentSubtitleIndex;
                                    return AnimatedOpacity(
                                      opacity: isCurrent ? 1.0 : 0.5,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        child: Text(
                                          subtitle.subtitle,
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: isCurrent ? 22.sp : 20.sp,
                                            fontWeight:
                                                isCurrent
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                Center(
                                  child: Text(
                                    'No subtitles available',
                                    style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _currentMedia.title,
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    AudioSlider(
                      position: position,
                      duration: safeDuration,
                      onChange: _audio.seek,
                    ),
                    SizedBox(height: 19.h),
                    AudioControls(
                      isSubtitleAvailable:
                          _currentMedia.subtitleInfo?.isNotEmpty == true,
                      isPlaying: _audio.isPlaying,
                      isMuted: _audio.isMuted,
                      isLyricsShown: _isLyricsShown,
                      onPlayPause: _audio.togglePlay,
                      onNext: _playNext,
                      onPrevious: _playPrevious,
                      onMute: _audio.toggleMute,
                      onLyrics: _togglePage,
                    ),
                    SizedBox(height: 27.h),
                  ],
                ),
              ),
            ),
            if (_showGoalPopup)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: CupertinoColors.black.withOpacity(0.4),
                    child: Center(
                      child: AchievementPopup(
                        onClose: () {
                          HapticFeedback.lightImpact();
                          setState(() => _showGoalPopup = false);
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurButton({required String icon}) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              height: icon == arrowLeft ? 24.h : 20.h,
              colorFilter: const ColorFilter.mode(
                CupertinoColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
