import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate(
      {required ScrollController controller,
      required PaginationProvider provider}) {
    if (controller.offset > controller.position.maxScrollExtent - 400) {
      provider.paginate(fetchMore: true);
    }
  }
}
