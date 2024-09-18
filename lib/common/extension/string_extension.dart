import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

extension ReadMoreExtension on String {
  ReadMoreText toReadMoreText(BuildContext context, {int trimLines = 3}) =>
      ReadMoreText(
        this,
        trimMode: TrimMode.Line,
        colorClickableText: Theme.of(context).colorScheme.error,
        trimLines: trimLines,
        trimCollapsedText: '더보기',
        trimExpandedText: '  간략히',
        textAlign: TextAlign.start,
      );
}

extension ObjectLogExtension on Object {
  void print() {
    debugPrint(toString());
  }
}
