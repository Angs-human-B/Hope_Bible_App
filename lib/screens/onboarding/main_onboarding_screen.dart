import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Constants/global_variable.dart';
import '../../Constants/image.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
import '../../widgets/back_button.dart';


class MainOnboardingScreen extends StatefulWidget {
  Widget child;
  MainOnboardingScreen(this.child,{super.key});

  @override
  State<MainOnboardingScreen> createState() => _MainOnboardingScreenState();
}

class _MainOnboardingScreenState extends State<MainOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Image.asset(spotLight, fit: BoxFit.cover,width:  MediaQuery.of(context).size.width,)),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              // color: Colors.black,
              child: widget.child
            ),
            Positioned(
                top: 690.h,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 18.w),
                  child: NextButton(),
                )),
            Positioned(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 18.w),
                child: Container(
                alignment: Alignment.bottomLeft,
                height: 62.h,
                child: Row(
                  children: [
                    // BackButtonOnboarding(),
                    SizedBox(width: 26.w),
                    ProgressBar(progress: currentProgress/totalProgress),
                  ],
                ),
                            ),
              ),)
          ],
        ),
      ),
    );
  }

}
