import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/colors.dart';
import '../../Constants/icons.dart';
import '../../screens/Search/search_screen.dart';

class CupertinoSearchBar extends StatelessWidget {
  const CupertinoSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (_) => const SearchScreen()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: AbsorbPointer(
          child: CupertinoSearchTextField(
            placeholder: 'Search for keyword or phrase',
            placeholderStyle: TextStyle(color: textFieldGrey),
            backgroundColor: textFieldGrey.withValues(alpha: .22),
            padding: EdgeInsets.all(15.sp),
            prefixInsets: EdgeInsets.only(left: 15.w),
            prefixIcon: SvgPicture.asset(searchIcon, height: 16.h),
            suffixInsets: EdgeInsets.only(right: 15.w),
            itemColor: textFieldGrey,
          ),
        ),
      ),
    );
  }
}
