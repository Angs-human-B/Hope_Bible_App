import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';

class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});

  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  DateTime selectedDate = DateTime(2025, 4);

  final Map<int, double> sampleStreakData = {
    1: 0.8,
    2: 0.4,
    3: 0.9,
    4: 0.7,
    5: 1.0,
    6: 0.2,
    7: 0.0,
    8: 0.6,
    9: 0.3,
    10: 0.85,
    11: 0.8,
    12: 0.4,
    13: 0.9,
    14: 0.7,
    15: 1.0,
    16: 0.2,
    17: 0.0,
    18: 0.6,
    19: 0.3,
    20: 0.85,
    21: 0.8,
    22: 0.4,
    23: 0.9,
    24: 0.7,
    25: 1.0,
    26: 0.2,
    27: 0.0,
    28: 0.6,
    29: 0.3,
    30: 0.85,
    31: 0.5
  };

  void _showMonthPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300.h,
        color: secondaryGrey,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDate = DateTime(newDate.year, newDate.month);
            });
          },
        ),
      ),
    );
  }

  List<Widget> _buildStreakGrid(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startDate = DateTime(month.year, month.month, 1);
    final startWeekday = startDate.weekday;

    List<Widget> dateWidgets = [];

    // Empty slots for days before the first day of the month
    for (int i = 1; i < startWeekday; i++) {
      dateWidgets.add(SizedBox(width: 40.w, height: 40.h));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      double progress = sampleStreakData[day] ?? 0.0;
      dateWidgets.add(
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 4.w,
                valueColor: AlwaysStoppedAnimation(accentWhite),
                backgroundColor: textWhite.withValues(alpha: .2),
              ),
              Text(
                '$day',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return dateWidgets;
  }

  Widget _buildMonthSection(DateTime month) {
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 36.h),
        Text(
          _monthName(month.month),
          style: TextStyle(
            color: accentWhite,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdays
              .map((day) => SizedBox(
            width: 43.w,
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: textGrey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ))
              .toList(),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: _buildStreakGrid(month),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime nextMonth = DateTime(selectedDate.year, selectedDate.month + 1);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        leading: GestureDetector(
          onTap: () => _showMonthPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    width: 44.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        calenderIcon,
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
              SizedBox(width: 12.w),
              Text(
                '${_monthName(selectedDate.month)} ${selectedDate.year}',
                style: TextStyle(
                  color: textWhite,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    closeIcon,
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
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSection(selectedDate),
              _buildMonthSection(nextMonth),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
