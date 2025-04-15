import 'package:flutter/cupertino.dart';

class FeatureCard extends StatelessWidget {
  final bool isSmall;

  const FeatureCard({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final double width = isSmall ? 140 : 200;
    final double height = isSmall ? 220 : 290;

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
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Text(
          //     "THE ARK\nPART II",
          //     style: TextStyle(
          //       color: CupertinoColors.white,
          //       fontSize: isSmall ? 14 : 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
