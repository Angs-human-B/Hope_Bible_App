import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../widgets/AudioPlayer/animated_equalizer.dart';

class FloatingAudioPlayer extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final Duration position;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const FloatingAudioPlayer({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.position,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = '${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}';

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 72.h),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 390.w,
              height: 96.h,
              decoration: BoxDecoration(
                color: cardGrey.withOpacity(0.4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  // thumbnail,equalizer
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          thumbnailUrl,
                          width: 64.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/the_ark.png',
                            width: 64.w,
                            height: 64.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.h,
                        child: AnimatedEqualizer(
                          isActive: isPlaying,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),

                  // title, time
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                          child: Marquee(
                            text: title,
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            blankSpace: 24.w,
                            velocity: 20.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            startPadding: 10.0,
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // play/pause, prev/next
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onPrevious,
                        child: SvgPicture.asset(
                          previousIcon,
                          height: 20.h,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: onPlayPause,
                        child: SvgPicture.asset(
                          isPlaying ? pauseIcon : playIcon,
                          height: 40.h,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: onNext,
                        child: SvgPicture.asset(
                          nextIcon,
                          height: 20.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
