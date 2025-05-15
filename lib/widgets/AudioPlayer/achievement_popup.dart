import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';

import '../../Constants/icons.dart';

class AchievementPopup extends StatelessWidget {
  final VoidCallback onClose;

  const AchievementPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 340.w,
        height: 445.h,
        decoration: BoxDecoration(
          color: secondaryBlack.withValues(alpha: .88),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: textFieldGrey, width: .5),
          image: const DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage('assets/images/goal_popup_bg.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:  EdgeInsets.all(16.sp),
                  child: GestureDetector(
                    onTap: onClose,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          width: 45.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              closeIcon,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                CupertinoColors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Text(
                  'Daily Goal Achieved',
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Keep Going!',
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
