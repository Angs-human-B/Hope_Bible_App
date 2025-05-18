import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class AnimatedEqualizer extends StatefulWidget {
  final bool isActive;
  final Color color;

  const AnimatedEqualizer({
    super.key,
    required this.isActive,
    required this.color,
  });

  @override
  State<AnimatedEqualizer> createState() => _AnimatedEqualizerState();
}

class _AnimatedEqualizerState extends State<AnimatedEqualizer>
    with TickerProviderStateMixin {
  final _random = math.Random();
  final int _barCount = 3;

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (_) => _createController());
    _animations = List.generate(_barCount, (i) => _createAnimation(i));
    if (widget.isActive) _startAll();
  }

  AnimationController _createController() {
    return AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000 + _random.nextInt(1000)), // Slower
    );
  }

  Animation<double> _createAnimation(int i) {
    double start = _randomHeight();
    double end = _randomHeight();

    final controller = _controllers[i];
    final animation = Tween<double>(begin: start, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    controller
      ..reset()
      ..forward();

    controller.addStatusListener((status) {
      if (!mounted || !widget.isActive) return;
      if (status == AnimationStatus.completed) {
        double newStart = animation.value;
        double newEnd = _randomHeight();

        _animations[i] = Tween<double>(begin: newStart, end: newEnd).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
        );
        controller
          ..duration = Duration(milliseconds: 1000 + _random.nextInt(1000))
          ..forward(from: 0);
      }
    });

    return animation;
  }

  double _randomHeight() => 0.3 + _random.nextDouble() * 0.7;

  void _startAll() {
    for (int i = 0; i < _barCount; i++) {
      _controllers[i].forward();
    }
  }

  void _stopAll() {
    for (final controller in _controllers) {
      controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controllers[0].isAnimating) {
      _startAll();
    } else if (!widget.isActive) {
      _stopAll();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_barCount, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 4,
                height: 10 + (_animations[i].value * 12),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
