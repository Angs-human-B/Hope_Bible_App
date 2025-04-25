import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/auth/auth_page.dart';

class PricingScreen2 extends StatelessWidget {
  const PricingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Color(0xFF31343A),
                ],
                stops: [0.41, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  width: double.infinity,
                  // height: 351.h,
                  padding: EdgeInsets.symmetric(horizontal:20.w,vertical: 12.h),
                  decoration: BoxDecoration(
                    color: cardGrey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.sp),
                      topRight: Radius.circular(32.sp),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 94.w,
                        height: 7,
                        decoration: BoxDecoration(
                          color: textWhite.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4.sp),
                        ),
                      ),
                      SizedBox(height: 35.h),
                      Text(
                        'Unlock Your Mindful \nJournal Today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFF5DE),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(color: textWhite.withValues(alpha: 0.08)),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24.sp,
                            backgroundColor: textGrey,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unlock Full Access',
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Great for conversion at the pricing tier',
                                  style: TextStyle(
                                    color: textGrey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Divider(color: textWhite.withValues(alpha: 0.08)),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (_) => const AuthPage()),
                                  (route) => false,
                            );
                        },
                        child: Container(
                          height: 56.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: accentYellow,
                            borderRadius: BorderRadius.circular(40.sp),
                          ),
                          child: Center(
                            child: Text(
                              "Only at \$24.99/y",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: secondaryBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ],
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
