import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductProvider, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(productRepositoryProvider);
    return ProductProvider(repository: repository);
  },
);

class ProductProvider
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductProvider({required super.repository});
}
