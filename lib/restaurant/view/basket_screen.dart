import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/user/model/basket_item_model.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return DefaultLayout(
      title: '장바구니',
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final BasketItemModel model = basket[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProductCard.fromProductModel(
                      model: model.product,
                      onSubtract: () => ref
                          .read(basketProvider.notifier)
                          .removeFromBasket(id: model.product.id),
                      onAdd: () =>
                          ref.read(basketProvider.notifier).addToBasket(
                                product: model.product,
                              ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 32,
                    ),
                itemCount: basket.length),
          ),
        ],
      ),
    );
  }
}
