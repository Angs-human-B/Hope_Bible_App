import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FeatureCard extends StatelessWidget {
  final bool isSmall;

  const FeatureCard({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final double width = isSmall ? 152.w : 200.w;
    final double height = isSmall ? 234.h : 290.h;

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/the_ark.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Optional overlay
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Frosted icon box
          Positioned(
            bottom: 8,
            left: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CupertinoColors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/bookmark.svg',
                      width: 18.w,
                      height: 18.h,
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
        ],
      ),
    );
  }
}
