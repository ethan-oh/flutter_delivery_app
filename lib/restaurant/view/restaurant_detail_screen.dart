import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String name;
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
    required this.name,
  });

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: name,
      child: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const CircularProgressIndicator());
          }

          final item = RestaurantDetailModel.fromJson(
            snapshot.data!,
          );
          return CustomScrollView(
            slivers: [
              _buildTop(model: item),
              _buildLabel(),
              _buildProducts(products: item.products),
            ],
          );
        },
      ),
    );
  }

  SliverPadding _buildLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding _buildProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        isDetail: true,
        model: model,
      ),
    );
  }
}
