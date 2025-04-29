import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/icons.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final bool isMuted;
  final bool isLyricsShown;
  final VoidCallback onPlayPause, onNext, onPrevious, onMute, onLyrics;

  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.isMuted,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onMute,
    required this.onLyrics,
    required this.isLyricsShown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onPrevious,
              child: SvgPicture.asset(previousIcon),
            ),
            SizedBox(width: 38.w),
            GestureDetector(
              onTap: onPlayPause,
              child: SvgPicture.asset(isPlaying ? pauseIcon : playIcon),
            ),
            SizedBox(width: 38.w),
            GestureDetector(onTap: onNext, child: SvgPicture.asset(nextIcon)),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onMute,
              child: SvgPicture.asset(
                height: 27.h,
                isMuted ? mutedIcon : unMutedIcon,
              ),
            ),
            GestureDetector(
              onTap: onLyrics,
              child: SvgPicture.asset(
                height: 24.h,
                isLyricsShown ? lyricsCutIcon : lyricsIcon,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
