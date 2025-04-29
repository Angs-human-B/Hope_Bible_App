import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/colors.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // value from 0.0 to 1.0

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 8.h,
          width: 280.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: CupertinoColors.systemGrey.withOpacity(
              0.4,
            ), // Background color
          ),
          child: Stack(
            children: [
              // Progress fill
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(
                  0.0,
                  1.0,
                ), // Ensures value stays between 0 and 1
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: accentWhite, // Active progress color
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
