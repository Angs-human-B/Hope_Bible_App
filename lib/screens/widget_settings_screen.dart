import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';

class WidgetSettingsScreen extends StatelessWidget {
  const WidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
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
        middle: Text(
          'Widget Settings',
          style: TextStyle(
            color: textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Container(
                height: 385.h,
                width: 350.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.sp),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/wallpaper_widgetScreen.png",
                    ),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset("assets/images/Left Side.svg"),
                        SvgPicture.asset("assets/images/Right Side.svg"),
                      ],
                    ),
                    // Image.asset("assets/images/widgtes_sample.png"),
                    // SvgPicture.asset("assets/images/widgtes_sample.svg"),
                    SizedBox(height: 19.h),
                    Container(
                      height: 142.h,
                      width: 304.w,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.sp),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/dailyverse_widget_bg.png",
                          ),
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"But those who hope in the Lord will renew their strength."'
                                .toUpperCase(),
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.001,
                              wordSpacing: 0.005,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'DAILY VERSE',
                            style: TextStyle(
                              color: textWhite,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 148.h,
                          width: 150.w,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.sp),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [secondaryBlack, cardGrey],
                              stops: [0.5, 1.0],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 43.w,
                                height: 43.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: .7,
                                      strokeWidth: 4.w,
                                      valueColor: AlwaysStoppedAnimation(
                                        accentWhite,
                                      ), // accentYellow
                                      backgroundColor: textFieldGrey.withValues(
                                        alpha: .2,
                                      ),
                                    ),

                                    Text(
                                      DateTime.now().day.toString(),
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/streak_fill_icon.svg",
                                        height: 16.h,
                                      ),
                                      SizedBox(width: 1.h),
                                      Text(
                                        '7d ',
                                        style: TextStyle(
                                          color: textWhite,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 1.h),
                                      Column(
                                        children: [
                                          SizedBox(height: 3.5.h),
                                          Text(
                                            'Streak',
                                            style: TextStyle(
                                              color: textWhite,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 2.h),
                                      Text(
                                        '19 ',
                                        style: TextStyle(
                                          color: textWhite,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 1.h),
                                      Column(
                                        children: [
                                          SizedBox(height: 3.5.h),
                                          Text(
                                            'Check-ins',
                                            style: TextStyle(
                                              color: textWhite,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 148.h,
                          width: 150.w,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.sp),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [secondaryBlack, cardGrey],
                              stops: [0.5, 1.0],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 47.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.sp),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/the_ark.png',
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/bible_logo.svg",
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'RESUME • JUN 2',
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'The Ark, Part 2',
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 25.h,
                                width: 55.w,
                                padding: EdgeInsets.all(3.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  color: textGrey.withValues(alpha: .8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/play_icon_small.svg",
                                      height: 10.h,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '6m',
                                      style: TextStyle(
                                        color: textWhite,
                                        fontSize: 14.sp,
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
                  ],
                ),
              ),
              SizedBox(height: 35.h),
              Text(
                'Get Widgets on your Home screen',
                style: TextStyle(
                  color: textWhite,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    '| ',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Long press any area on home screen',
                    style: TextStyle(
                      color: hintTextGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '| ',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Tap the “Edit” button in the top left',
                    style: TextStyle(
                      color: hintTextGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '| ',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Look for “Christian” in the gallery',
                    style: TextStyle(
                      color: hintTextGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '| ',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Choose your preferred widget',
                    style: TextStyle(
                      color: hintTextGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '| ',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Tap “Add Widget”',
                    style: TextStyle(
                      color: hintTextGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
