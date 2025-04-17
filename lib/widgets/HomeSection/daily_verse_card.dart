import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';

class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.only(
          top: 18.h,
          bottom: 10.h,
          left: 18.w,
          right: 10.w,
        ),
        decoration: BoxDecoration(
          color: secondaryGrey,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for avatar + text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer yellow ring
                    Container(
                      width: 76.w, // Slightly bigger than avatar
                      height: 76.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentYellow,
                          width: 1.5.w,
                        ),
                      ),
                    ),
                    // Inner avatar
                    CircleAvatar(
                      radius: 34.w,
                      backgroundImage: AssetImage('assets/images/the_ark.png'),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DAILY VERSE",
                        style: TextStyle(
                          color: textWhite.withValues(alpha: .66),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '"But those who hope in the Lord will renew their strength."',
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 20.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Bottom row with verse + icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Isaiah 40:31",
                  style: TextStyle(
                    color: textWhite.withValues(alpha: .66),
                    fontSize: 14.sp,
                  ),
                ),
                Row(
                  children: [
                    _blackIconBox('assets/icons/download.svg'),
                    SizedBox(width: 8.w),
                    _blackIconBox('assets/icons/share.svg'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _blackIconBox(String svgAsset) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: SvgPicture.asset(
        svgAsset,
        width: 20.w,
        height: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
