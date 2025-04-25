import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/icons.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/OnboardingSection/auto_scroll_caraousel.dart';
import '../../widgets/back_button.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';

class Onboarding16Screen extends StatefulWidget {
  const Onboarding16Screen({super.key});

  @override
  State<Onboarding16Screen> createState() => _Onboarding16ScreenState();
}

class _Onboarding16ScreenState extends State<Onboarding16Screen> {
  final List<String> benefits = [
    'Reduces stress',
    'Improve Focus',
    'Enhance knowledge'
  ];
  Color _cardBackground = Color(0xFF1E1E1E);
  Color _iconBackground = Color(0xFF000000);
  Color _accentYellow   = Color(0xFFFFC943);
  Color _textWhite      = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50.h),
        SizedBox(height: 84.h),
        CommonText(onboarding16String, 30.sp, textAlign: TextAlign.start,),
        SizedBox(height: 17.h),
        CommonText(onboarding16String2, 14.sp, textAlign: TextAlign.start,textColor: textGrey,),
        SizedBox(height: 46.h),
        AutoScrollingImage(
          imageProvider: AssetImage(
            onboarding16,
          ),
          direction: ScrollDirection.leftToRight,

        ),
        SizedBox(height: 46.h,),
        CommonText("Benefits of Personalized Nutrition", 20.sp, textAlign: TextAlign.start,),
        SizedBox(height: 20.h,),
        Container(
          decoration: BoxDecoration(
    color: _cardBackground,
    borderRadius: BorderRadius.circular(16.r),
          ),
          // ListView.separated scrolls if needed and builds dividers automatically
          child: SizedBox(
    // constrain height so ListView knows its bounds
    height: benefits.length * (32.h + 24.h),
    child: ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      separatorBuilder: (_, __) => Divider(
        height: 1, thickness: 1, color: Colors.grey[800],
        indent: 16.w, endIndent: 16.w,
      ),
      itemBuilder: (context, i) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 32.w, height: 32.w,
              decoration: BoxDecoration(
                color: _iconBackground,
                shape: BoxShape.circle,
              ),
              child:Image.asset(star),
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
        )
      ],
    );
  }
}
