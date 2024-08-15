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

  static String dateTimeToString(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }

  static String intToPriceString(int amount) {
    // 숫자를 문자열로 변환
    String amountStr = amount.toString();
    // 결과를 저장할 변수
    String formatted = '';

    // 문자열을 뒤에서부터 처리하면서 천 단위로 쉼표 추가
    for (int i = amountStr.length - 1; i >= 0; i--) {
      // 현재 인덱스
      int indexFromEnd = amountStr.length - 1 - i;
      // 천 단위로 쉼표 추가
      if (indexFromEnd > 0 && indexFromEnd % 3 == 0) {
        formatted = ',$formatted';
      }
      // 결과 문자열에 현재 문자 추가
      formatted = amountStr[i] + formatted;
    }

    // '원' 단위 추가
    formatted += '원';

    return formatted;
  }
}
