import 'package:delivery_flutter_app/common/component/pagination_list_view.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/product/provider/product_provider.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      emptyText: '음식 정보가 존재하지 않습니다.',
      lastWidget: const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text('마지막 음식입니다'),
      ),
      itemBuilder: (context, index, model) => GestureDetector(
        onTap: () => context.goNamed(
          RestaurantDetailScreen.routeName,
          pathParameters: {
            'rid': model.restaurant.id,
          },
        ),
        child: ProductCard.fromProductModel(model: model),
      ),
    );
  }
}
