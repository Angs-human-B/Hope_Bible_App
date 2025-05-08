import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/OnboardingSection/auto_scroll_caraousel.dart';

class Onboarding16Screen extends StatefulWidget {
  const Onboarding16Screen({super.key});

  @override
  State<Onboarding16Screen> createState() => _Onboarding16ScreenState();
}

class _Onboarding16ScreenState extends State<Onboarding16Screen> {
  final List<String> benefits = [
    'Reduces stress',
    'Improve Focus',
    'Enhance knowledge',
  ];
  final Color _cardBackground = Color(0xFF1E1E1E);
  final Color _iconBackground = Color(0xFF000000);
  final Color _textWhite = CupertinoColors.white;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: CommonText(
            onboarding16String,
            30.sp,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 17.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),

          child: CommonText(
            onboarding16String2,
            14.sp,
            textAlign: TextAlign.start,
            textColor: textGrey,
          ),
        ),
        SizedBox(height: 46.h),
        AutoScrollingImage(
          imageProvider: AssetImage(onboarding16),
          direction: ScrollDirection.leftToRight,
        ),
        SizedBox(height: 46.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),

          child: CommonText(
            "Benefits of Personalized Nutrition",
            20.sp,
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Container(
            decoration: BoxDecoration(
              color: _cardBackground,
              borderRadius: BorderRadius.circular(16.r),
            ),
            // ListView.separated scrolls if needed and builds dividers automatically
            child: SizedBox(
              // constrain height so ListView knows its bounds
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 16.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: benefits.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1,
                      thickness: 1,
                      color: CupertinoColors.systemGrey,
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                itemBuilder:
                    (context, i) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: _iconBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(star, color: textWhite),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              benefits[i],
                              style: TextStyle(
                                color: _textWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
