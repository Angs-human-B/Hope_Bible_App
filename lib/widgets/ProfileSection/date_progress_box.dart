import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hope/Constants/colors.dart';

class DateProgressBox extends StatelessWidget {
  const DateProgressBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71.w,
      height: 81.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'THU',
            style: TextStyle(
              color: textGrey,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 43.w,
            height: 43.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.85, // Progress (0.0 to 1.0)
                  strokeWidth: 3.w,
                  valueColor: AlwaysStoppedAnimation(accentWhite), // accentYellow
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  '3',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
