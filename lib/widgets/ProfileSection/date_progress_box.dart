import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst, Obx;
import 'package:hope/Constants/colors.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../streak/controllers/streak.controller.dart' show StreakController;

class DateProgressBox extends StatefulWidget {
  const DateProgressBox({super.key});

  @override
  State<DateProgressBox> createState() => _DateProgressBoxState();
}

class _DateProgressBoxState extends State<DateProgressBox> {
  final controller = Get.find<StreakController>();
  bool hasStreak = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStreakHistoryFn({}, context);
      final currentDate = DateTime.now();
      hasStreak = controller.streakDates.any(
        (date) =>
            date.year == currentDate.year &&
            date.month == currentDate.month &&
            date.day == currentDate.day,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 71.w,
      height: 81.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(DateTime.now()),
            style: TextStyle(
              color: textGrey,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 43.w,
            height: 43.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(() {
                  return controller.isLoading.value
                      ? const SizedBox()
                      : CircularProgressIndicator(
                        value: hasStreak ? 1.0 : 0.0, // Progress (0.0 to 1.0)
                        strokeWidth: 3.w,
                        valueColor: AlwaysStoppedAnimation(
                          accentWhite,
                        ), // accentYellow
                        backgroundColor: Colors.transparent,
                      );
                }),
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
        ],
      ),
    );
  }
}
