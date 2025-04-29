// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../widgets/common_text.dart';
import '../../widgets/common_text_box.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;

class CommonOnboardingScreen extends StatefulWidget {
  List<String> categoryList;
  String title;
  String nextRoute;
  String type;

  CommonOnboardingScreen(
    this.categoryList,
    this.title,
    this.nextRoute,
    this.type, {
    super.key,
  });

  @override
  State<CommonOnboardingScreen> createState() => _CommonOnboardingScreenState();
}

class _CommonOnboardingScreenState extends State<CommonOnboardingScreen>
    with AutomaticKeepAliveClientMixin {
  int selectedIdx = 9;

  isOptionSelected(String type) {
    if (type == 'age') {
      ageIsSelected = true;
    }
    if (type == 'attendChurch') {
      attendChurchIsSelected = true;
    }
    if (type == 'meditate') {
      meditateIsSelected = true;
    }
    if (type == 'studyGroup') {
      studyGroupIsSelected = true;
    }
    if (type == 'spiritualJourney') {
      journeyIsSelected = true;
    } else {
      return false;
    }
  }

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onboardingController.isSelected.value = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 50.h),
            SizedBox(height: 84.h),
            //
            CommonText(widget.title, 30.sp),
            SizedBox(height: 40.h),
            SizedBox(
              height: 256.h,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          isOptionSelected(widget.type);
                          setState(() {
                            selectedIdx = index;
                          });
                          onboardingController.isSelected.value = true;
                          onboardingController.updatePageData(
                            widget.type,
                            widget.categoryList[index],
                          );
                        },
                        child: SizedBox(
                          width:
                              350.w, // width is ignored when inside Expanded/full width
                          height: 52.h,
                          child: CommonTextBox(
                            widget.categoryList[index],
                            selectedIdx == index ? accentWhite : textWhite,
                            selectedIdx == index
                                ? accentWhite.withOpacity(0.25)
                                : secondaryGrey,
                            borderColor:
                                selectedIdx == index
                                    ? accentWhite
                                    : CupertinoColors.transparent,
                            clicked: selectedIdx == index ? true : false,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  );
                },
              ),
            ),
            // SizedBox(height: 55.h,)
          ],
        ),
        //
      ],
    );
  }
}
