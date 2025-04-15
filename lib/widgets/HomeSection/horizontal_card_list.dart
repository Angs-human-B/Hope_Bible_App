import 'package:flutter/cupertino.dart';
import 'feature_card.dart';
import 'section_header.dart';

class HorizontalCardList extends StatelessWidget {
  final String title;

  const HorizontalCardList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(
          height: 240, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 5,
            itemBuilder: (context, index) => const FeatureCard(isSmall: true),
          ),
        ),
      ],
    );
  }
}
