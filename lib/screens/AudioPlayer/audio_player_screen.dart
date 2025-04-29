import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../services/audio_service.dart';
import '../../widgets/AudioPlayer/audio_controls.dart';
import '../../widgets/AudioPlayer/audio_slider.dart';
import '../../Models/lyric_line.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioService _audio = AudioService();
  late final PageController _pageController;
  bool _isLyricsShown = false;
  List<LyricLine> _lines = [];
  int _currentLyricIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audio.init();
    _audio.positionStream.listen((_) => setState(() {}));
    _loadLyrics();
  }

  Future<void> _loadLyrics() async {
    _lines = await LyricLine.loadFromAsset('assets/lyrics/sample.lrc');
    setState(() {});
    _audio.positionStream.listen((pos) {
      final idx = LyricLine.findIndex(_lines, pos);
      if (idx != _currentLyricIndex) {
        setState(() => _currentLyricIndex = idx);
      }
    });
  }

  @override
  void dispose() {
    _audio.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _isLyricsShown = (page == 1));
  }

  void _togglePage() {
    final newPage = _isLyricsShown ? 0 : 1;
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = _audio.position;
    final duration = _audio.duration;
    final safeDuration = duration.inMilliseconds == 0
        ? const Duration(milliseconds: 1)
        : duration;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // blurred background
          Positioned.fill(
            child: Image.asset('assets/images/the_ark.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: CupertinoColors.black.withValues(alpha: 0.7)),
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
                        onTap: () => Navigator.pop(context),
                        child: _buildBlurButton(icon: arrowLeft),
                      ),
                      Text(
                        'The ArK Part 01',
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: null,
                        child: _buildBlurButton(icon: bookmarkIcon),
                      ),
                    ],
                  ),
                  Expanded(
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
                              image: const DecorationImage(
                                image: AssetImage('assets/images/the_ark.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                          ),
                        ),
                        // Page 1: Lyrics list
                        ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          itemCount: _lines.length,
                          itemBuilder: (context, index) {
                            final line = _lines[index];
                            final isCurrent = index == _currentLyricIndex;
                            return AnimatedOpacity(
                              opacity: isCurrent ? 1.0 : 0.5,
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Text(
                                  line.text,
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: isCurrent ? 22.sp : 20.sp,
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'The ArK Part 01',
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
                    isPlaying: _audio.isPlaying,
                    isMuted: _audio.isMuted,
                    isLyricsShown: _isLyricsShown,
                    onPlayPause: _audio.togglePlay,
                    onNext: _audio.next,
                    onPrevious: _audio.previous,
                    onMute: _audio.toggleMute,
                    onLyrics: _togglePage,
                  ),
                  SizedBox(height: 27.h),
                ],
              ),
            ),
          ),
        ],
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
