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
}
