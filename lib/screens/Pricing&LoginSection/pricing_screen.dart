import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  int _selectedPlan = 0;

  String get _priceText =>
      _selectedPlan == 0 ? '\$49.00/y' : '\$24.99/m';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/pricing_screen_bg.png',
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0, -1),
                  end: const Alignment(0, 1),
                  colors: [
                    secondaryBlack.withOpacity(.12),
                    secondaryBlack,
                  ],
                  stops: const [0.0, 0.52],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            width: 44.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: accentWhite.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                closeIcon,
                                height: 24.h,
                                colorFilter: ColorFilter.mode(
                                  textWhite,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 115.h),
                  Text(
                    'Transform your \nSpiritual Journey \nToday',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  // Yearly option with badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PlanOption(
                        label: 'Yearly',
                        subtitle: 'Annual Plan',
                        price: '\$49.00/y',
                        selected: _selectedPlan == 0,
                        onTap: () => setState(() => _selectedPlan = 0),
                      ),
                      if (_selectedPlan == 0)
                        Positioned(
                          top: -12.h,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 82.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: textWhite,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Save 15%',
                                style: TextStyle(
                                  color: secondaryBlack,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  PlanOption(
                    label: 'Monthly',
                    subtitle: 'Monthly Plan',
                    price: '\$24.99/m',
                    selected: _selectedPlan == 1,
                    onTap: () => setState(() => _selectedPlan = 1),
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                    child: Text(
                      'Restore Purchase',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: accentWhite,
                        borderRadius: BorderRadius.circular(30.sp),
                      ),
                      child: Center(
                        child: Text(
                          'Subscribe for $_priceText',
                          style: TextStyle(
                            color: secondaryBlack,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanOption extends StatelessWidget {
  final String label, subtitle, price;
  final bool selected;
  final VoidCallback onTap;

  const PlanOption({
    super.key,
    required this.label,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? accentWhite : cardGrey;
    final bgColor = selected
        ? accentWhite.withOpacity(0.2)
        : cardGrey.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              selected ? radioSelectedIcon : radioUnselectedIcon,
              color: selected ? accentWhite : hintTextGrey,
              width: 21.w,
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                color: textWhite,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}