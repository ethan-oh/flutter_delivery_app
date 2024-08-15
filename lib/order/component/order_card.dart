import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:delivery_flutter_app/common/utils/data_utils.dart';
import 'package:delivery_flutter_app/order/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productsSummary;
  final String productsDetail;
  final int price;

  const OrderCard({
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productsSummary,
    required this.productsDetail,
    required this.price,
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
            '${e.product.name} ${e.count}개 ${e.product.price * e.count}원 ')
        .toList()
        .join('\n');

    return OrderCard(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${DataUtils.dateTimeToString(orderDate)} ',
                ),
                const TextSpan(
                  text: '주문완료',
                  style: TextStyle(
                      color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        ExpansionTile(
          initiallyExpanded: false,
          shape: const Border(),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: image,
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '$productsSummary ${DataUtils.intToPriceString(price)}',
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontWeight: FontWeight.w300,
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text(productsDetail),
          ],
        ),
      ],
    );
  }
}
