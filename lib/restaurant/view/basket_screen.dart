import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/common/utils/data_utils.dart';
import 'package:delivery_flutter_app/order/provider/order_provider.dart';
import 'package:delivery_flutter_app/order/view/order_done_screen.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/user/model/basket_item_model.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    int deliveryFee = 3000;
    int basketTotalCost = ref.read(basketProvider.notifier).totalPrice;
    return DefaultLayout(
      title: '장바구니',
      persistentFooterButtons: basket.isEmpty
          ? null
          : [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '총 상품 금액',
                          style: TextStyle(color: BODY_TEXT_COLOR),
                        ),
                        Text(
                          DataUtils.intToPriceString(basketTotalCost),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '배달비',
                          style: TextStyle(color: BODY_TEXT_COLOR),
                        ),
                        Text(
                          '+ ${DataUtils.intToPriceString(deliveryFee)}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '총 결제 예상 금액',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          DataUtils.intToPriceString(
                              basketTotalCost + deliveryFee),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () async {
                          final resp = await ref
                              .read(orderProvider.notifier)
                              .postOrder();
                          if (resp) {
                            context.goNamed(OrderDoneScreen.routeName);
                            ref.read(basketProvider.notifier).clearBasket();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('결제 실패')));
                          }
                        },
                        child: const Text('결제하기'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
      child: basket.isEmpty
          ? const Center(
              child: Text('장바구니에 상품이 없습니다.'),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final BasketItemModel model = basket[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProductCard.fromProductModel(
                    model: model.product,
                    onSubtract: () => ref
                        .read(basketProvider.notifier)
                        .removeFromBasket(id: model.product.id),
                    onAdd: () => ref.read(basketProvider.notifier).addToBasket(
                          product: model.product,
                        ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                    height: 32,
                  ),
              itemCount: basket.length),
    );
  }
}
