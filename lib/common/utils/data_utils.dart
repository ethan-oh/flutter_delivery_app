import 'dart:convert';
import 'package:delivery_flutter_app/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => 'http://$ip$value';

  static List<String> listPathToUrls(List values) {
    return values.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final encoded = stringToBase64.encode(plain);
    return encoded;
  }

  static String dateTimeToFormattedString(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }
}

extension IntExtensions on int {
  String toPriceString() {
    String amountStr = toString();
    String formatted = '';
    for (int i = amountStr.length - 1; i >= 0; i--) {
      int indexFromEnd = amountStr.length - 1 - i;
      if (indexFromEnd > 0 && indexFromEnd % 3 == 0) {
        formatted = ',$formatted';
      }
      formatted = amountStr[i] + formatted;
    }
    formatted += '원';
    return formatted;
  }
}
