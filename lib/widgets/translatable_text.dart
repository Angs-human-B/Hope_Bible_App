import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../core/controllers/translation.controller.dart';

class TranslatableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatableText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TranslationController>();

    return FutureBuilder<String>(
      future: controller.translateText(text),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Text(
            snapshot.data ?? text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            key: ValueKey(snapshot.data ?? text),
          ),
        );
      },
    );
  }
}
