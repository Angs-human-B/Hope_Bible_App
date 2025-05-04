import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/screens/profile_settings_screen.dart';
import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import '../../screens/streaks_screen.dart';
import '../../streak/controllers/streak.controller.dart' show StreakController;
import '../../utilities/app.constants.dart' show AppConstants;
import '../../utilities/text.utility.dart' show AllText;
import 'date_progress_box.dart';
import 'package:get/get.dart';

class ProfileUpperContainer extends StatefulWidget {
  const ProfileUpperContainer({super.key});

  @override
  State<ProfileUpperContainer> createState() => _ProfileUpperContainerState();
}

class _ProfileUpperContainerState extends State<ProfileUpperContainer> {
  final SignUpController controller = Get.find<SignUpController>();
  final streakController = Get.find<StreakController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: secondaryGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.sp),
          bottomRight: Radius.circular(28.sp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ProfileSettingsScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34.w,
                      backgroundColor: CupertinoColors.systemGrey,
                      child: Icon(
                        CupertinoIcons.person,
                        color: textWhite,
                        size: 34.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return controller.isLoading.value
                              ? SizedBox()
                              : Text(
                                (controller.userDetails.name?.isNotEmpty ??
                                        false)
                                    ? controller.userDetails.name!
                                    : controller.userDetails.email?.split(
                                          '@',
                                        )[0] ??
                                        "",
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                        }),
                        SizedBox(height: 4.h),
                        Obx(() {
                          return controller.isLoading.value
                              ? SizedBox()
                              : Text(
                                controller.userDetails.email ?? "",
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Divider(height: 1),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateProgressBox(),
                  SizedBox(width: 16.w),

                  /// Expanded middle section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AllText(
                          text: "My Goal",
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Obx(() {
                              return controller.isLoading.value
                                  ? SizedBox()
                                  : Text(
                                    "${AppConstants.readingTime.split(':')[0]} Minutes",
                                    style: TextStyle(
                                      color: textWhite,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                            }),
                            Text(
                              " / day",
                              style: TextStyle(
                                color: textGrey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: accentWhite,
                            borderRadius: BorderRadius.circular(99.sp),
                          ),
                          child: GestureDetector(
                            onTap: () => _showChangeGoalDialog(context),
                            child: AllText(
                              text: "Change My Goal",
                              style: TextStyle(
                                color: secondaryBlack,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Streak icon container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const StreaksScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(99.sp),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            streaksIcon,
                            color: accentWhite,
                            height: 18.h,
                            width: 24.w,
                          ),
                          SizedBox(width: 4.w),
                          Obx(() {
                            return controller.isLoading.value
                                ? SizedBox()
                                : Text(
                                  controller.userDetails.currentStreak
                                          ?.toString() ??
                                      "0",
                                  style: TextStyle(
                                    color: textWhite,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangeGoalDialog(BuildContext context) {
    final currentMinutes =
        int.tryParse(AppConstants.readingTime.split(':')[0]) ?? 9;
    final selectedMinutes = currentMinutes.obs;

    // Generate time options from 2 minutes to 2 hours
    final List<int> timeOptions = [];
    for (int i = 2; i <= 120; i++) {
      if (i <= 30) {
        timeOptions.add(i); // Every minute up to 30
      } else if (i <= 60 && i % 5 == 0) {
        timeOptions.add(i); // Every 5 minutes from 30 to 60
      } else if (i % 15 == 0) {
        timeOptions.add(i); // Every 15 minutes from 60 to 120
      }
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400.h,
          decoration: BoxDecoration(
            color: secondaryGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 60.h,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: secondaryGrey.withOpacity(0.9),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: accentWhite, fontSize: 17.sp),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Reading Goal',
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: accentWhite,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await streakController.updateReadingTimeFn({
                            "readingTime":
                                "${selectedMinutes.value.toString().padLeft(2, '0')}:00",
                          }, context);
                          setState(() {
                            AppConstants.readingTime =
                                "${selectedMinutes.value.toString().padLeft(2, '0')}:00";
                          });
                          Get.snackbar(
                            backgroundColor: CupertinoColors.black,
                            'Success',
                            'Reading goal updated successfully',
                            snackPosition: SnackPosition.TOP,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          Get.snackbar(
                            backgroundColor: CupertinoColors.black,
                            'Error',
                            'Failed to update reading goal: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(20.sp),
              //   padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
              //   decoration: BoxDecoration(
              //     color: secondaryGrey.withOpacity(0.5),
              //     borderRadius: BorderRadius.circular(15.r),
              //     border: Border.all(
              //       color: CupertinoColors.systemGrey.withOpacity(0.3),
              //       width: 0.5,
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(CupertinoIcons.time, color: accentYellow, size: 24.sp),
              //       SizedBox(width: 10.w),
              //       Obx(
              //         () => Text(
              //           '${selectedMinutes.value} minutes per day',
              //           style: TextStyle(
              //             color: textWhite,
              //             fontSize: 17.sp,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: CupertinoColors.black.withOpacity(0.8),
                  itemExtent: 40.h,
                  scrollController: FixedExtentScrollController(
                    initialItem: timeOptions.indexOf(currentMinutes),
                  ),
                  onSelectedItemChanged: (index) {
                    selectedMinutes.value = timeOptions[index];
                  },
                  children:
                      timeOptions.map((minutes) {
                        return Center(
                          child: Text(
                            '$minutes minutes',
                            style: TextStyle(color: textWhite, fontSize: 20.sp),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
