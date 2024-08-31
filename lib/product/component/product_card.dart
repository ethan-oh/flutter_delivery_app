import 'package:delivery_flutter_app/common/utils/data_utils.dart';
import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.image,
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    this.onSubtract,
    this.onAdd,
  });

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      price.toPriceString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Column(
            children: [
              const SizedBox(height: 16),
              _Footer(
                total: (basket.firstWhere((e) => e.product.id == id).count *
                    basket.firstWhere((e) => e.product.id == id).product.price),
                count: basket.firstWhere((e) => e.product.id == id).count,
                onSubtract: onSubtract!,
                onAdd: onAdd!,
              ),
            ],
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final int total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  const _Footer({
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    var foregroundColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '총금액: ${total.toPriceString()}',
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              buildButton(
                context,
                icon: count != 1 ? Icons.remove : Icons.delete_outlined,
                backgroundColor: count != 1
                    ? foregroundColor
                    : Theme.of(context).colorScheme.error,
                foregroundColor: backgroundColor,
                ontap: onSubtract,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              buildButton(
                context,
                backgroundColor: foregroundColor,
                foregroundColor: backgroundColor,
                icon: Icons.add,
                ontap: onAdd,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildButton(context,
      {required IconData icon,
      required VoidCallback ontap,
      required Color backgroundColor,
      required Color foregroundColor,
      required}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        border: Border.all(color: backgroundColor, width: 2),
      ),
      child: InkWell(
        onTap: ontap,
        child: Icon(
          icon,
          color: foregroundColor,
          size: 20,
        ),
      ),
    );
  }
}
