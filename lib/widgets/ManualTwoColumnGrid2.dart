import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';
import '../Constants/global_variable.dart';
import 'common_text_box.dart';

class ManualTwoColumnGrid2 extends StatefulWidget {
  const ManualTwoColumnGrid2({
    Key? key,
    required this.denomination,
    this.gridHeight = 326, // default = 600.h
    this.itemWidth = 167, // default = 167.w
    this.itemHeight = 52, // default =  65.h
    this.crossSpacing = 15,
    this.mainSpacing = 15,
    this.horizontalPadding = 5,
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

  @override
  State<ManualTwoColumnGrid2> createState() => _ManualTwoColumnGrid2State();
}

class _ManualTwoColumnGrid2State extends State<ManualTwoColumnGrid2> {
  int selectedIdx = 9;

  @override
  Widget build(BuildContext context) {
    //
    // Build a list of rows manually so we can give the last item full width.
    //
    final List<Widget> rows = [];

    for (int i = 0; i < widget.denomination.length; i += 2) {
      final bool hasPair = i + 1 < widget.denomination.length;

      if (hasPair) {
        // ── Normal two‑column row ────────────────────────────────────────────
          rows.add(
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      bibleVersionIsSelected = true;
                      isSelected.value = true;
                      setState(() {
                        selectedIdx = i;
                      });
                    },
                    child: _buildBox(
                        widget.denomination[i],
                        widget.itemHeight,
                        widget.itemWidth,
                        selectedIdx == i
                            ? accentYellow.withOpacity(0.25)
                            : secondaryGrey,
                        selectedIdx == i ? accentYellow : textWhite,
                        selectedIdx == i ? accentYellow : Colors.transparent,
                        selectedIdx == i ? true : false

                    ),
                  ),
                ),
                SizedBox(width: widget.crossSpacing),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      bibleVersionIsSelected = true;
                      isSelected.value = true;
                      setState(() {
                        selectedIdx = i+1;
                      });
                    },
                    child: _buildBox(
                        widget.denomination[i+1],
                        widget.itemHeight,
                        widget.itemWidth,
                        selectedIdx == i+1
                            ? accentYellow.withOpacity(0.25)
                            : secondaryGrey,
                        selectedIdx == i+1 ? accentYellow : textWhite,
                        selectedIdx == i+1 ? accentYellow : Colors.transparent,
                        selectedIdx == i+1 ? true : false

                    ),
                  ),
                ),
              ],
            ),
          );
      } else {
        // ── Last odd item → full‑width ──────────────────────────────────────
        rows.add(
          GestureDetector(
            onTap: () {
              isSelected.value = true;
              bibleVersionIsSelected = true;
              setState(() {
                selectedIdx = i;
              });
            },
            child: _buildBox(
                widget.denomination[i],
                widget.itemHeight,
                800.w,
                selectedIdx == i
                    ? accentYellow.withOpacity(0.25)
                    : secondaryGrey,
                selectedIdx == i ? accentYellow : textWhite,
                selectedIdx == i ? accentYellow : Colors.transparent,
                selectedIdx == i ? true : false

            ),
          ),
        );
      }

      // Add vertical spacing between rows (except after the very last one).
      if (i + 2 < widget.denomination.length) {
        rows.add(SizedBox(height: widget.mainSpacing));
      }
    }

    // ── Final layout container ───────────────────────────────────────────────
    return SizedBox(
      height: widget.gridHeight.h,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: Column(children: rows),
      ),
    );
  }

  /// Builds a single tile wrapped in a SizedBox to keep the original height.
  Widget _buildBox(
      String label,
      double height,
      double width,
      Color backgroundColor,
      Color textColor,
      Color borderColor,
      bool clicked
      ) => SizedBox(
    width: width, // width is ignored when inside Expanded/full width
    height: height,
    child: CommonTextBox(label, textColor, backgroundColor, borderColor: borderColor,clicked: clicked,),
  );
}