import 'package:delivery_flutter_app/common/extension/build_context_extension.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '총 상품 금액',
                        ),
                        Text(
                          basketTotalCost.toPriceString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '배달비',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        Text(
                          '+ ${deliveryFee.toPriceString()}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '총 결제 예상 금액',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          (basketTotalCost + deliveryFee).toPriceString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    FilledButton(
                      onPressed: () => _showPaymentDialog(context, ref),
                      child: const Text('결제하기'),
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
                    thickness: 0,
                  ),
              itemCount: basket.length),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref) {
    context.showConfirmDialog(
      title: '알림',
      content: '결제하시겠습니까?',
      onConfirm: () => _processPayment(context, ref),
    );
  }

  Future<void> _processPayment(BuildContext context, WidgetRef ref) async {
    final resp = await ref.read(orderProvider.notifier).postOrder();
    if (resp) {
      context.goNamed(OrderDoneScreen.routeName);
      ref.read(basketProvider.notifier).clearBasket();
    } else {
      context.showSnackBar('결제 실패');
    }
  }
}
