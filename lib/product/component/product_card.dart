import 'package:delivery_flutter_app/common/const/colors.dart';
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
                      style: const TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DataUtils.intToPriceString(price),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: _Footer(
                  total: (basket.firstWhere((e) => e.product.id == id).count *
                      basket
                          .firstWhere((e) => e.product.id == id)
                          .product
                          .price),
                  count: basket.firstWhere((e) => e.product.id == id).count,
                  onSubtract: onSubtract!,
                  onAdd: onAdd!,
                ),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '총금액: ${DataUtils.intToPriceString(total)}',
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              buildButton(
                icon: count != 1 ? Icons.remove : Icons.delete_outlined,
                color: count != 1
                    ? PRIMARY_COLOR
                    : const Color.fromARGB(255, 207, 44, 32),
                ontap: onSubtract,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              buildButton(
                icon: Icons.add,
                ontap: onAdd,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildButton({
    required IconData icon,
    required VoidCallback ontap,
    Color color = PRIMARY_COLOR,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        border: Border.all(color: color, width: 2),
      ),
      child: InkWell(
        onTap: ontap,
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
