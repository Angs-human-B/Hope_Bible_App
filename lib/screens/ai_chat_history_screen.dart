import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';

class AiChatHistoryScreen extends StatelessWidget {
  AiChatHistoryScreen({super.key});
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, String>> historyData = List.generate(
    15,
    (index) => {
      'title': 'Your Faith, Your Way',
      'subtitle':
          'Instantly tailor your experience based on your denomination, age, and spiritual journey—get content that actually speaks to you.',
    },
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    arrowLeft,
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
        middle: Text(
          'History',
          style: TextStyle(
            color: textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              CupertinoSearchTextField(
                focusNode: _searchFocusNode,
                placeholder: 'Search chat history',
                placeholderStyle: TextStyle(color: textFieldGrey),
                backgroundColor: textFieldGrey.withOpacity(0.22),
                padding: EdgeInsets.all(15.sp),
                prefixInsets: EdgeInsets.only(left: 15.w),
                prefixIcon: SvgPicture.asset(searchIcon, height: 16.h),
                suffixInsets: EdgeInsets.only(right: 15.w),
                itemColor: textFieldGrey,
                style: TextStyle(color: textWhite),
                onChanged: (value) {},
                onTap: () {},
                onSuffixTap: () {
                  _searchFocusNode.unfocus();
                },
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardGrey.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: textWhite.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: ListView.separated(
                    itemCount: historyData.length,
                    separatorBuilder:
                        (_, __) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Container(
                            color: textWhite.withValues(alpha: 0.2),
                            height: 1.h,
                            width: 325.w,
                          ),
                        ),
                    itemBuilder: (context, index) {
                      final item = historyData[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            historyClockIcon,
                            width: 24.w,
                            height: 24.h,
                            colorFilter: const ColorFilter.mode(
                              CupertinoColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      color: textWhite,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item['subtitle']!,
                                    style: TextStyle(
                                      color: hintTextGrey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                            },
                            child: SvgPicture.asset(
                              closeIcon,
                              width: 16.w,
                              height: 16.h,
                              colorFilter: const ColorFilter.mode(
                                CupertinoColors.systemGrey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
