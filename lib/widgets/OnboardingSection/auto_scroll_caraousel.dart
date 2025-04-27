// lib/auto_scrolling_image.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Direction of the auto-scroll animation.
enum ScrollDirection { leftToRight, rightToLeft }

class AutoScrollingImage extends StatefulWidget {
  /// The image to scroll (e.g. AssetImage, NetworkImage, etc.)
  final ImageProvider imageProvider;

  /// Height of the scrolling viewport
  final double height;

  /// How fast to scroll in pixels per second
  final double velocity;

  /// Direction of the scroll animation
  final ScrollDirection direction;

  /// Gap between consecutive image copies when looping
  final double gap;

  const AutoScrollingImage({
    Key? key,
    required this.imageProvider,
    this.height = 132,
    this.velocity = 50,
    this.direction = ScrollDirection.leftToRight,
    this.gap = 8.0, // default small gap
  }) : super(key: key);

  @override
  _AutoScrollingImageState createState() => _AutoScrollingImageState();
}

class _AutoScrollingImageState extends State<AutoScrollingImage> {
  final ScrollController _scrollController = ScrollController();
  double? _imageWidth;
  late double _imageHeight;
  bool _scrolling = false;

  @override
  void initState() {
    super.initState();
    _imageHeight = widget.height.h;
    _resolveImage();
  }

  void _resolveImage() {
    widget.imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, _) {
        final ui.Image img = info.image;
        final aspect = img.width / img.height;
        setState(() {
          _imageWidth = _imageHeight * aspect;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_scrolling && _imageWidth != null) {
            _scrolling = true;
            // set initial offset
            if (widget.direction == ScrollDirection.rightToLeft) {
              _scrollController.jumpTo(_imageWidth! + widget.gap.w);
            } else {
              _scrollController.jumpTo(0);
            }
            _startScrolling();
          }
        });
      }),
    );
  }

  Future<void> _startScrolling() async {
    if (_imageWidth == null) return;
    final double distance = _imageWidth! + widget.gap.w;
    final int durationMs = ((distance / widget.velocity) * 1000).round();

    while (mounted) {
      if (widget.direction == ScrollDirection.leftToRight) {
        await _scrollController.animateTo(
          distance,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.linear,
        );
        _scrollController.jumpTo(0);
      } else {
        await _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.linear,
        );
        _scrollController.jumpTo(distance);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageWidth == null) {
      return SizedBox(
        height: _imageHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: _imageHeight,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        separatorBuilder: (_, __) => SizedBox(width: widget.gap.w),
        itemBuilder: (_, __) => SizedBox(
          width: _imageWidth,
          height: _imageHeight,
          child: Image(
            image: widget.imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
