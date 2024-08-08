import 'package:delivery_flutter_app/common/component/pagination_list_view.dart';
import 'package:delivery_flutter_app/order/component/order_card.dart';
import 'package:delivery_flutter_app/order/model/order_model.dart';
import 'package:delivery_flutter_app/order/provider/order_provider.dart';
import 'package:flutter/widgets.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: (context, index, model) => OrderCard.fromModel(model: model),
    );
  }
}
