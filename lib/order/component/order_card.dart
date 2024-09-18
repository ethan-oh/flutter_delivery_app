import 'package:delivery_flutter_app/common/utils/data_utils.dart';
import 'package:delivery_flutter_app/order/model/order_model.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsSummary;
  final String productsDetail;
  final int price;
  final int productCount;
  final String rid;

  const OrderCard({
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productsSummary,
    required this.productsDetail,
    required this.price,
    required this.productCount,
    required this.rid,
    super.key,
  });

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    final productsSummary = model.products.length < 2
        ? model.products.first.product.name
        : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    final productsDetail = model.products
        .map((e) =>
            '${e.product.name} ${e.count}개  ${(e.product.price * e.count).toPriceString()}')
        .toList()
        .join('\n');

    return OrderCard(
      productCount: model.products.length,
      orderDate: model.createdAt,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50.0,
        width: 50.0,
        fit: BoxFit.cover,
      ),
      name: model.restaurant.name,
      productsSummary: productsSummary,
      price: model.totalPrice,
      productsDetail: productsDetail,
      rid: model.restaurant.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commonTitle = InkWell(
      onTap: () {
        context.pushNamed(
          RestaurantDetailScreen.routeName,
          pathParameters: {'rid': rid},
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
          ),
        ],
      ),
    );

    final commonSubtitle = Text(
      '$productsSummary ${price.toPriceString()}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w300,
      ),
    );

    final commonLeading =
        ClipRRect(borderRadius: BorderRadius.circular(16.0), child: image);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${DataUtils.dateTimeToFormattedString(orderDate)} ',
              ),
              TextSpan(
                text: '주문완료',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        if (productCount > 1)
          ExpansionTile(
            minTileHeight: 0,
            initiallyExpanded: false,
            tilePadding: const EdgeInsets.all(0),
            shape: const Border(),
            title: commonTitle,
            subtitle: commonSubtitle,
            leading: commonLeading,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(productsDetail),
            ],
          )
        else
          ListTile(
            minTileHeight: 0,
            contentPadding: const EdgeInsets.all(0),
            title: commonTitle,
            subtitle: commonSubtitle,
            leading: commonLeading,
          ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.surfaceContainerHighest,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Text.rich(
  //           TextSpan(
  //             children: [
  //               TextSpan(
  //                 text: '${DataUtils.dateTimeToFormattedString(orderDate)} ',
  //               ),
  //               TextSpan(
  //                 text: '주문완료',
  //                 style: TextStyle(
  //                   color: Theme.of(context).colorScheme.primary,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         ExpansionTile(
  //           initiallyExpanded: false,
  //           tilePadding: const EdgeInsets.all(0),
  //           shape: const Border(),
  //           leading: ClipRRect(
  //             borderRadius: BorderRadius.circular(16.0),
  //             child: image,
  //           ),
  //           title: Text(
  //             name,
  //             style: const TextStyle(
  //               fontSize: 16.0,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           subtitle: Text(
  //             '$productsSummary ${price.toPriceString()}',
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.onSurfaceVariant,
  //               fontWeight: FontWeight.w300,
  //             ),
  //           ),
  //           expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(productsDetail),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
