
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:intl/intl.dart';

import '../../widgets/common_text.dart';

class Onboarding33Screen extends StatefulWidget {
  const Onboarding33Screen({super.key});

  @override
  State<Onboarding33Screen> createState() => _Onboarding33ScreenState();
}

class _Onboarding33ScreenState extends State<Onboarding33Screen> {

  int _selectedSlot = 0;
  TimeOfDay _customTime = TimeOfDay(hour: 20, minute: 30);
  Duration _selectedDuration = const Duration(hours: 20, minutes: 30);
  String _formattedTime(Duration d) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, d.inHours, d.inMinutes % 60);
    return DateFormat.jm().format(dt);
  }
  Future<void> _pickCupertinoTime() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 250.h,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            // “Done” button bar
            Container(

              height: 44.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            // The actual picker
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: _selectedDuration,
                onTimerDurationChanged: (newDuration) {
                  setState(() {
                    _selectedSlot = -1;  // clear preset
                    _selectedDuration = newDuration;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSlotButton({
    required String icon,
    required String label,
    required int index,
  }) {
    final bool selected = _selectedSlot == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSlot = index),
        child: Container(
          height: 108.h,
          width: 111.3.w,
          decoration: BoxDecoration(
            color: selected? cardGrey: secondaryGrey,
            border: Border.all(color: selected? Colors.white : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 50.h),
            SizedBox(height: 84.h),
            //
            CommonText('When should we remind you?', 30.sp),
            SizedBox(height: 40.h),
            Row(
              children: [
                _buildSlotButton(
                  icon:"assets/images/morning.png", // morning icon
                  label: "Morning",
                  index: 0,
                ),
                SizedBox(width: 10.w,),
                _buildSlotButton(
                  icon: "assets/images/mid-day.png", // mid-day icon
                  label: "Mid-day",
                  index: 1,
                ),
                SizedBox(width: 10.w,),
                _buildSlotButton(
                  icon: "assets/images/night.png", // night icon
                  label: "Night",
                  index: 2,
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Text(
              "or",
              textAlign: TextAlign.center,
              style: TextStyle(color: textGrey, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            // Or custom time
            Text(
              "We'll remind you at…",
              textAlign: TextAlign.center,
              style: TextStyle(color: textWhite, fontSize: 18.sp),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _pickCupertinoTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: secondaryGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formattedTime(_selectedDuration),
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                    SizedBox(width: 20.w),
                    Image.asset('assets/images/clock.png'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              "*Daily scripture helped them grow—\nand your story could be next.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12.sp),
            ),

            // SizedBox(height: 55.h,)
          ],
        ),
        //
      ],
    );
  }
}
