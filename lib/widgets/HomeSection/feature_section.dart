import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key});

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  final PageController _pageController = PageController(viewportFraction: 0.6);
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
      height: 320,
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
                padding: const EdgeInsets.symmetric(horizontal: 6),
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
      width: 210,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: AssetImage('assets/images/the_ark.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  CupertinoColors.black.withOpacity(0.6),
                  CupertinoColors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            left: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(68, 68, 68, 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.08),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/bookmark.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Add to list',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 13,
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
            child: SvgPicture.asset(
              'assets/icons/play.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
