import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

import 'package:hope/screens/AudioPlayer/audio_player_screen.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key});

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  final PageController _pageController = PageController(viewportFraction: 0.55);
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 345.h,
      width: 230.w,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          final isCurrent = index == currentPage.round();
          final scale = isCurrent ? 1.0 : 0.92;
          final opacity = isCurrent ? 1.0 : 0.7;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: const _CupertinoFeatureCard(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CupertinoFeatureCard extends StatelessWidget {
  const _CupertinoFeatureCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345.h,
      width: 230.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.sp),
        image: const DecorationImage(
          image: AssetImage('assets/images/the_ark.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.sp),
          //     gradient: LinearGradient(
          //       begin: Alignment.bottomCenter,
          //       end: Alignment.topCenter,
          //       colors: [
          //         CupertinoColors.black.withOpacity(0.6),
          //         CupertinoColors.black.withOpacity(0.2),
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 16,
            left: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(
                  height: 44.h,
                  width: 130.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(68, 68, 68, 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.08),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/bookmark.svg',
                        width: 12.w,
                        height: 15.h,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Add to list',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 12,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const AudioPlayerScreen()),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/play.svg',
                width: 44.w,
                height: 44.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
