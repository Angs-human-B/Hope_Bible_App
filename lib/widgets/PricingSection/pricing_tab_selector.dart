import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';

class PricingTabSelector extends StatefulWidget {
  const PricingTabSelector({super.key});

  @override
  _PricingTabSelectorState createState() => _PricingTabSelectorState();
}

class _PricingTabSelectorState extends State<PricingTabSelector> {
  String _selectedPlan = 'Annual';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      width: 357.w,
      decoration: BoxDecoration(
        color: cardGrey.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(99.sp),
        border: Border.all(color: CupertinoColors.transparent,width: 4.h),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99.sp),
        child: Row(
          children: [
            _buildTab('Annual'),
            _buildTab('Monthly'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String plan) {
    bool isSelected = _selectedPlan == plan;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPlan = plan;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? accentYellow : CupertinoColors.transparent,
            borderRadius: BorderRadius.circular(99.sp),
          ),
          child: Text(
            plan,
            style: TextStyle(
              color: isSelected ? secondaryBlack : textWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
