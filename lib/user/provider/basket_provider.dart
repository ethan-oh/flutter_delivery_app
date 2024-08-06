import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/user/model/basket_item_model.dart';
import 'package:delivery_flutter_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider = StateNotifierProvider(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(repository: repository);
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  BasketProvider({required this.repository}) : super([]);

  // getBasket() async {
  //   state = await repository.getBasket();
  // }

  addToBasket({required ProductModel product}) {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }
  }

  removeToBasket({required String id}) {
    final existingProduct = state.firstWhereOrNull((e) => e.product.id == id);

    if (existingProduct == null) {
      return;
    }

    if (existingProduct.count == 1) {
      state = state.where((e) => e.product.id != id).toList();
    } else {
      state = state
          .map((e) => e.product.id == id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }
  }
}
