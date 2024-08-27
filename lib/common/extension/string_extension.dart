import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

extension ReadMoreExtension on String {
  ReadMoreText toReadMoreText({int trimLines = 3}) => ReadMoreText(
        this,
        trimMode: TrimMode.Line,
        trimLines: trimLines,
        trimCollapsedText: '더보기',
        trimExpandedText: '  간략히',
        textAlign: TextAlign.start,
      );
}
