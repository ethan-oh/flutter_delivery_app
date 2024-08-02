import 'package:delivery_flutter_app/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) => 'http://$ip$value';

  static List<String> listPathToUrls(List values) {
    return values.map((e) => pathToUrl(e)).toList();
  }
}
