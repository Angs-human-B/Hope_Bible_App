import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/widgets/back_button.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/common_text_box.dart';
import 'package:hope/widgets/next_button.dart';
import 'package:hope/widgets/progress_bar.dart';

class Onboarding2Screen extends StatefulWidget {
  const Onboarding2Screen({super.key});

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen> {
  List<String> denomination = ["Baptist", "Methodic", "Catholic", "Presbyterian",
    "Lutheran", "Pentecostal", "Orthodox", "Other", "Non-denominational"];
  int selectedIdx = 9;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
       child: Container(
         height: MediaQuery.of(context).size.height,
         child: Column(
           children: [
             Container(
               alignment: Alignment.bottomCenter,
               height: 120.h,
               child: Row(
                 children: [
                   SizedBox(width: 10.w,),
                   BackButtonOnboarding(),
                   SizedBox(width: 35.w,),
                   ProgressBar()
                 ],
               ),
             ),
             SizedBox(height: 50.h,),
             CommonText("What is your Denomination?", 35.sp),
             SizedBox(height: 40.h,),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: 10.0),
               child: ManualTwoColumnGrid(
                 denomination: denomination,
               ),
             ),
             // SizedBox(height: 30.h,),
             NextButton("Next", "01")

           ],
         ),
       ),
    );
  }
}


class ManualTwoColumnGrid extends StatelessWidget {
  const ManualTwoColumnGrid({
    Key? key,
    required this.denomination,
    this.gridHeight = 480,               // default = 600.h
    this.itemWidth = 167,                // default = 167.w
    this.itemHeight = 65,                // default =  65.h
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
  Widget build(BuildContext context) {
    //
    // Build a list of rows manually so we can give the last item full width.
    //
    final List<Widget> rows = [];

    for (int i = 0; i < denomination.length; i += 2) {
      final bool hasPair = i + 1 < denomination.length;

      if (hasPair) {
        // ── Normal two‑column row ────────────────────────────────────────────
        if(i == 6){
          print(true);
          rows.add(
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    print(i);
                  },
                    child: _buildBox(denomination[i], 52.h, 235.w)),
                SizedBox(width: crossSpacing),
                GestureDetector(
                    onTap: (){
                      print(i+1);
                    },
                    child: _buildBox(denomination[i + 1], 52.h, 99.w)),
              ],
            ),
          );
        }
        else{
        rows.add(
          Row(
            children: [
              Expanded(child: _buildBox(denomination[i], itemHeight.h, itemWidth.w) ),
              SizedBox(width: crossSpacing),
              Expanded(child: _buildBox(denomination[i + 1], itemHeight.h, itemWidth.w)),
            ],
          ),
        );}
      } else {
        // ── Last odd item → full‑width ──────────────────────────────────────
        rows.add(_buildBox(denomination[i], itemHeight.h, 800.w));
      }

      // Add vertical spacing between rows (except after the very last one).
      if (i + 2 < denomination.length) {
        rows.add(SizedBox(height: mainSpacing));
      }
    }

    // ── Final layout container ───────────────────────────────────────────────
    return SizedBox(
      height: gridHeight.h,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(children: rows),
      ),
    );
  }

  /// Builds a single tile wrapped in a SizedBox to keep the original height.
  Widget _buildBox(String label, double height, double width) => SizedBox(
    width: width,   // width is ignored when inside Expanded/full width
    height: height,
    child: CommonTextBox(label, textWhite, secondaryGrey),
  );
}
