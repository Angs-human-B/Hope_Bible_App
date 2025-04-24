import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/screens/onboarding/main_onboarding_screen.dart';

// import all your onboarding screens:
import '../../Constants/global_variable.dart';
import '../../Constants/image.dart';
import '../../widgets/OnboardingSection/next_button.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
import '../../widgets/back_button.dart';
import 'Onboarding16_screen.dart';
import 'common_onboarding_screen.dart';
import 'onboarding11_screen.dart';
import 'onboarding13_screen.dart';
import 'onboarding15_screen.dart';
import 'onboarding17_screen.dart';
import 'onboarding18_screen.dart';
import 'onboarding19_screen.dart';
import 'onboarding1_screen.dart';
import 'onboarding20_screen.dart';
import 'onboarding21_screen.dart';
import 'onboarding23_screen.dart';
import 'onboarding24_screen.dart';
import 'onboarding25_screen.dart';
import 'onboarding2_screen.dart';
// …
import 'onboarding26_screen.dart';
import 'onboarding3_screen.dart';
import 'onboarding5_screen.dart';
import 'onboarding6_screen.dart';
import 'onboarding7_screen.dart';
import 'onboarding9_screen.dart';

class OnboardingPager extends StatefulWidget {
  @override
  _OnboardingPagerState createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<OnboardingPager> {

  // 1) Put all your screens into a list:
  List<Widget> _pages = [
    Onboarding1Screen(controller),
    Onboarding2Screen(),
    Onboarding3Screen(),
  CommonOnboardingScreen(
  ageGroup,
  onboarding4String,
  'o5'
  ),
    Onboarding5Screen(),
    Onboarding6Screen(),
    Onboarding7Screen(),
    CommonOnboardingScreen(
        readingFrequencies,
        onboarding8String,
        'o9'
    ),
    Onboarding9Screen(),
    CommonOnboardingScreen(
        churchGoingFrequencies,
        onboarding10String,
        'o11'
    ),
    Onboarding11Screen(),
    CommonOnboardingScreen(
        studyGroup,
        onboarding12String,
        'o13'
    ),
    Onboarding13Screen(),
    CommonOnboardingScreen(
        spiritualStages,
        onboarding14String,
        'o15'
    ),
    Onboarding15Screen(),
    Onboarding16Screen(),
    Onboarding17Screen(),
    Onboarding18Screen(),
    Onboarding19Screen(),
    Onboarding20Screen(),
    Onboarding21Screen(),
    // Onboarding22Screen(),
    Onboarding23Screen(),
    Onboarding24Screen(),
    Onboarding25Screen(),
    Onboarding26Screen(),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();


  }
  
  getBackgroundImage(int index){
    print(index);
    if(index ==10){
      return onboarding11;
    }
    if(index ==21){
      return onboarding23;
    }
    if(index ==22){
      return onboarding24;
    }
    if(index ==23){
      return onboarding25;
    }
    if(index ==24){
      return onboarding26;
    }
    else{
      return spotLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          // if(index != 0){
            return SafeArea(
              bottom: false,
              child: CupertinoPageScaffold(
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(getBackgroundImage(index), fit: BoxFit.cover,width:  MediaQuery.of(context).size.width,)),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: index !=0? 18.w: 0),
                        // color: Colors.black,
                        child: _pages[index]
                    ),
                    if(index  !=0)
                    Positioned(
                        top: 690.h,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 18.w),
                          child: GestureDetector(
                            onTap: (){
                              controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                              child: NextButton()
                          ),
                        )),
                    if(index  !=0)
                    Positioned(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 18.w),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 62.h,
                          child: Row(
                            children: [
                              BackButtonOnboarding(controller),
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
          // }
        },
      ),
    );
  }
}


