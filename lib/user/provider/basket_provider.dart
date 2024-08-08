import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/user/model/basket_item_model.dart';
import 'package:delivery_flutter_app/user/model/patch_basket_body.dart';
import 'package:delivery_flutter_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(repository: repository);
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  BasketProvider({required this.repository}) : super([]) {
    getBasket();
  }

  int get totalPrice => state.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.count);

  Future<void> getBasket() async {
    state = await repository.getBasket();
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                  productId: e.product.id, count: e.count),
            )
            .toList(),
      ),
    );
  }

  Future<void> clearBasket() async {
    state = [];
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: [],
      ),
    );
  }

  addToBasket({required ProductModel product}) async {
    final oldState = state;
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

    try {
      await patchBasket();
    } catch (e) {
      state = oldState;
    }
  }

  removeFromBasket({required String id, bool isDelete = false}) async {
    final oldState = state;
    final existingProduct = state.firstWhereOrNull((e) => e.product.id == id);

    if (existingProduct == null) {
      return;
    }

    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != id).toList();
    } else {
      state = state
          .map((e) => e.product.id == id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }

    try {
      await patchBasket();
    } catch (e) {
      state = oldState;
    }
  }
}
