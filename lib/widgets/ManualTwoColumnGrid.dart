import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';
import 'common_text_box.dart';

class ManualTwoColumnGrid extends StatefulWidget {
  const ManualTwoColumnGrid({
    Key? key,
    required this.denomination,
    this.gridHeight = 324, // default = 600.h
    this.itemWidth = 167, // default = 167.w
    this.itemHeight = 52, // default =  65.h
    this.crossSpacing = 14,
    this.mainSpacing = 14,
    this.horizontalPadding = 0,
    this.onItemSelected,
    this.selectedIndex = 9,
  }) : super(key: key);

  /// Data to show in each tile.
  final List<String> denomination;

  /// Colors coming from your theme.

  /// Sizing / spacing (before `.h` / `.w` is applied).
  final double gridHeight;
  final double itemWidth;
  final double itemHeight;
  final double crossSpacing;
  final double mainSpacing;
  final double horizontalPadding;
  final Function(int)? onItemSelected;
  final int selectedIndex;

  @override
  State<ManualTwoColumnGrid> createState() => _ManualTwoColumnGridState();
}

class _ManualTwoColumnGridState extends State<ManualTwoColumnGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.gridHeight.h,
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding.w),
      child: Wrap(
        spacing: widget.crossSpacing.w,
        runSpacing: widget.mainSpacing.h,
        children: List.generate(
          widget.denomination.length,
          (index) => GestureDetector(
            onTap: () {
              widget.onItemSelected?.call(index);
            },
            child: SizedBox(
              width: widget.itemWidth.w,
              height: widget.itemHeight.h,
              child: CommonTextBox(
                widget.denomination[index],
                widget.selectedIndex == index ? accentYellow : textWhite,
                widget.selectedIndex == index
                    ? accentYellow.withOpacity(0.25)
                    : secondaryGrey,
                borderColor:
                    widget.selectedIndex == index
                        ? accentYellow
                        : Colors.transparent,
                clicked: widget.selectedIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
