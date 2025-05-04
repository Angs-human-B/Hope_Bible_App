import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../screens/ai_chat_history_screen.dart';

class AppBarHeader extends StatefulWidget {
  final Widget? title;

  const AppBarHeader({super.key, this.title});

  @override
  State<AppBarHeader> createState() => _AppBarHeaderState();
}

class _AppBarHeaderState extends State<AppBarHeader> {
  bool _showPopup = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _showPopup?160.h:60.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ClipRRect(
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
                          arrowLeft,
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

              Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  child: widget.title ?? const SizedBox.shrink(),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPopup = !_showPopup;
                        print("_showPopup: $_showPopup");
                      });
                    },
                    child: ClipRRect(
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
                              menuIcon,
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
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Popup
          if (_showPopup)
            Container(
              width: 140.w,
              // height: 100.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: secondaryGrey,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _showPopup = false);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AiChatHistoryScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          historyIcon,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            CupertinoColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "History",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Divider(color: textWhite.withValues(alpha: .2)),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showPopup = false);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          deleteIcon,
                          height: 24.sp,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFF24822),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Color(0xFFF24822),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
