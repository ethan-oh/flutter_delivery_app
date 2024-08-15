import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:delivery_flutter_app/order/model/order_model.dart';
import 'package:delivery_flutter_app/order/model/post_order_body.dart';
import 'package:delivery_flutter_app/order/repository/order_repository.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderProvider, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return OrderProvider(ref: ref, repository: repository);
  },
);

class OrderProvider extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderProvider({required super.repository, required this.ref});

  Future<bool> postOrder() async {
    try {
      final String id = const Uuid().v4();
      final basket = ref.read(basketProvider);
      final totalPrice = ref.read(basketProvider.notifier).totalPrice;
      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basket
              .map(
                (e) => PostOrderBodyProduct(
                    productId: e.product.id, count: e.count),
              )
              .toList(),
          totalPrice: totalPrice,
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      debugPrint('주문 갱신 에러 :$e');
      return false;
    }
  }
}
