import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List> paginateRestaurant() async {
      Dio dio = Dio();

      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      final resp = await dio.get(
        'http://$ip/restaurant',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return resp.data['data'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        child: Center(
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              // print(snapshot.data?.first);
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                itemBuilder: (context, index) {
                  final RestaurantModel restaurantModel =
                      RestaurantModel.fromJson(
                    json: snapshot.data![index],
                  );
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: restaurantModel.id,
                            name: restaurantModel.name,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: restaurantModel,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
