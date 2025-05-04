import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/utilities/app.constants.dart' show Utils;

import '../Constants/colors.dart';
import '../screens/onboarding/controllers/onboarding.controller.dart'
    show OnboardingController;
import 'common_text_box.dart';

class ManualTwoColumnGrid extends StatefulWidget {
  const ManualTwoColumnGrid({
    super.key,
    required this.denomination,
    this.gridHeight = 324, // default = 600.h
    this.itemWidth = 167, // default = 167.w
    this.itemHeight = 52, // default =  65.h
    this.crossSpacing = 14,
    this.mainSpacing = 14,
    this.horizontalPadding = 0,
  });

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
  State<ManualTwoColumnGrid> createState() => _ManualTwoColumnGridState();
}

class _ManualTwoColumnGridState extends State<ManualTwoColumnGrid> {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
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
        if (i == 6) {
          rows.add(
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    denominationIsSelected = true;
                    onboardingController.isSelected.value = true;
                    setState(() {
                      selectedIdx = i;
                    });

                    onboardingController.updatePageData(
                      'denomination',
                      widget.denomination[i],
                    );
                  },
                  child: _buildBox(
                    widget.denomination[i],
                    52.h,
                    235.w,
                    selectedIdx == i
                        ? accentWhite.withOpacity(0.25)
                        : secondaryGrey,
                    selectedIdx == i ? accentWhite : textWhite,
                    selectedIdx == i ? accentWhite : Colors.transparent,
                    selectedIdx == i ? true : false,
                  ),
                ),
                SizedBox(width: 9.w),
                GestureDetector(
                  onTap: () {
                    denominationIsSelected = true;
                    onboardingController.isSelected.value = true;
                    setState(() {
                      selectedIdx = i + 1;
                    });

                    onboardingController.updatePageData(
                      'denomination',
                      widget.denomination[i + 1],
                    );
                  },
                  child: _buildBox(
                    widget.denomination[i + 1],
                    52.h,
                    110.w,
                    selectedIdx == i + 1
                        ? accentWhite.withOpacity(0.25)
                        : secondaryGrey,
                    selectedIdx == i + 1 ? accentWhite : textWhite,
                    selectedIdx == i + 1 ? accentWhite : Colors.transparent,
                    selectedIdx == i + 1 ? true : false,
                  ),
                ),
              ],
            ),
          );
        } else {
          rows.add(
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      denominationIsSelected = true;
                      onboardingController.isSelected.value = true;
                      setState(() {
                        selectedIdx = i;
                      });
                      Utils.logger.e(selectedIdx);
                      Utils.logger.f(widget.denomination[i]);

                      onboardingController.updatePageData(
                        'denomination',
                        widget.denomination[i],
                      );
                    },
                    child: _buildBox(
                      widget.denomination[i],
                      widget.itemHeight,
                      widget.itemWidth,
                      selectedIdx == i
                          ? accentWhite.withOpacity(0.25)
                          : secondaryGrey,
                      selectedIdx == i ? accentWhite : textWhite,
                      selectedIdx == i ? accentWhite : Colors.transparent,
                      selectedIdx == i ? true : false,
                    ),
                  ),
                ),
                SizedBox(width: widget.crossSpacing),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      denominationIsSelected = true;
                      onboardingController.isSelected.value = true;
                      setState(() {
                        selectedIdx = i + 1;
                      });

                      onboardingController.updatePageData(
                        'denomination',
                        widget.denomination[i + 1],
                      );
                    },
                    child: _buildBox(
                      widget.denomination[i + 1],
                      widget.itemHeight,
                      widget.itemWidth,
                      selectedIdx == i + 1
                          ? accentWhite.withOpacity(0.25)
                          : secondaryGrey,
                      selectedIdx == i + 1 ? accentWhite : textWhite,
                      selectedIdx == i + 1 ? accentWhite : Colors.transparent,
                      selectedIdx == i + 1 ? true : false,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        // ── Last odd item → full‑width ──────────────────────────────────────
        rows.add(
          GestureDetector(
            onTap: () {
              setState(() {
                denominationIsSelected = true;
                onboardingController.isSelected.value = true;

                onboardingController.updatePageData(
                  'denomination',
                  widget.denomination[i],
                );

                selectedIdx = i;
              });
            },
            child: _buildBox(
              widget.denomination[i],
              widget.itemHeight,
              800.w,
              selectedIdx == i ? accentWhite.withOpacity(0.25) : secondaryGrey,
              selectedIdx == i ? accentWhite : textWhite,
              selectedIdx == i ? accentWhite : Colors.transparent,
              selectedIdx == i ? true : false,
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
    bool clicked,
  ) => SizedBox(
    width: width, // width is ignored when inside Expanded/full width
    height: height,
    child: CommonTextBox(
      label,
      textColor,
      backgroundColor,
      borderColor: borderColor,
      clicked: clicked,
    ),
  );
}
