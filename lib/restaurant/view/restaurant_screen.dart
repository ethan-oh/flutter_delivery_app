import 'package:delivery_flutter_app/common/component/pagination_list_view.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
      provider: restaurantProvider,
      emptyText: '레스토랑 정보가 존재하지 않습니다.',
      lastWidget: const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
          '마지막입니다.',
        ),
      ),
      itemBuilder: (context, index, model) => InkWell(
        onTap: () {
          context.goNamed(RestaurantDetailScreen.routeName,
              pathParameters: {'rid': model.id});
        },
        child: RestaurantCard.fromModel(
          model: model,
        ),
      ),
    );
  }
}
