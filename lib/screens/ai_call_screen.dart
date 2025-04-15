import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AICallScreen extends StatelessWidget {
  final String userName;

  const AICallScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: Color(0xFF0C111D),
      child: SafeArea(child: _AICallScreenBody()),
    );
  }
}

class _AICallScreenBody extends StatelessWidget {
  const _AICallScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final AICallScreen screen =
        context.findAncestorWidgetOfExactType<AICallScreen>()!;

    return Stack(
      children: [
        // Back Button
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              shape: BoxShape.circle,
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                CupertinoIcons.back,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ),
        ),

        // Greeting Box
        Align(
          alignment: const Alignment(0, -0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2F35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 24,
                    color: CupertinoColors.white,
                  ),
                  children: [
                    const TextSpan(text: "Hello, "),
                    TextSpan(
                      text: screen.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC943),
                      ),
                    ),
                    const TextSpan(text: "\nHow can I help?"),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom Buttons
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _SvgRoundIcon('assets/icons/mute.svg', radius: 48),
              _SvgRoundIcon(
                'assets/icons/callcut.svg',
                radius: 72,
                background: CupertinoColors.systemRed,
                iconColor: CupertinoColors.white,
                size: 32,
              ),
              _SvgRoundIcon('assets/icons/soundoff.svg', radius: 48),
            ],
          ),
        ),
      ],
    );
  }
}

class _SvgRoundIcon extends StatelessWidget {
  final String assetPath;
  final double radius;
  final Color background;
  final Color iconColor;
  final double size;

  const _SvgRoundIcon(
    this.assetPath, {
    this.radius = 60,
    this.background = const Color(0xFF444444),
    this.iconColor = CupertinoColors.white,
    this.size = 24,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
