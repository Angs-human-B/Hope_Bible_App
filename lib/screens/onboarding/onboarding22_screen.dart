import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/OnboardingSection/image_carousel.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
import '../../widgets/back_button.dart';
import '../../widgets/OnboardingSection/next_button.dart';


class Onboarding22Screen extends StatefulWidget {
  const Onboarding22Screen({super.key});

  @override
  State<Onboarding22Screen> createState() => _Onboarding22ScreenState();
}

class _Onboarding22ScreenState extends State<Onboarding22Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h,),
        SizedBox(height: 84.h),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 18.w),
          child: CommonText('Feeling Disconnected?', 36.sp, textAlign: TextAlign.start,),
        ),
        // SizedBox(height: 22.h),
        QuoteCarousel(),

      ],
    );
  }

}
