import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({super.key});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  late final PageController _controller;
  final _quotes = [
    'assets/images/quote1.png',
    'assets/images/quote2.png',
    'assets/images/quote3.png',
    'assets/images/quote4.png',
    'assets/images/quote5.png',
  ];

  @override
  void initState() {
    super.initState();
    final middle = _quotes.length ~/ 2; // centre index
    _controller = PageController(
      viewportFraction: 0.8,
      initialPage: middle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel
        SizedBox(
          height: 420.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: _quotes.length,
            itemBuilder: (_, i) => AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                final double page = _controller.hasClients
                    ? (_controller.page ?? _controller.initialPage!.toDouble())
                    : _controller.initialPage!.toDouble();
                double value = (page - i).abs().clamp(0.0, 1.0);
                final scale = 1 - (value * 0.1);
                return Center(
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Image.asset(
                  _quotes[i],
                  fit: BoxFit.contain,
                  width: 350.w,
                  height: 416.h,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Indicator with rectangle for active
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final double page = _controller.hasClients
                ? (_controller.page ?? _controller.initialPage!.toDouble())
                : _controller.initialPage!.toDouble();

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_quotes.length, (i) {
                final bool isActive = (i - page).abs() < 0.5;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isActive ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFFC72C)  // accentYellow
                        : const Color(0xFF3A3A3A), // secondaryGrey
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
