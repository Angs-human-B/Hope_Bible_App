import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';

class AudioSlider extends StatelessWidget {
  final Duration position, duration;
  final ValueChanged<Duration> onChange;

  const AudioSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final maxSeconds =
    duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;
    final currentSeconds = position.inSeconds.toDouble().clamp(0.0, maxSeconds);
    final sliderValue = currentSeconds / maxSeconds;

    return Column(
      children: [
        SizedBox(
          // width: 350.w,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              final local = box.globalToLocal(details.globalPosition);
              final percent = (local.dx / box.size.width).clamp(0.0, 1.0);
              final newPosition = Duration(seconds: (percent * maxSeconds).round());
              onChange(newPosition);
            },
            child: Container(
              height: 7.5.h,
              decoration: BoxDecoration(
                color: CupertinoColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: sliderValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _format(position),
              style: TextStyle(color: hintTextGrey,fontWeight: FontWeight.w600,fontSize: 12.sp),
            ),
            Text(
              _format(duration),
              style: TextStyle(color: hintTextGrey,fontWeight: FontWeight.w600,fontSize: 12.sp),
            ),
          ],
        ),
      ],
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
