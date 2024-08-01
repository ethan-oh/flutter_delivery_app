import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/common/dio/dio.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/repository/restaurant_repository.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<RestaurantModel>> paginateRestaurant() async {
      Dio dio = Dio();
      dio.interceptors.add(CustomInterceptor(storage, dio));

      final repository =
          RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

      final resp = await repository.paginate();
      return resp.data;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        child: Center(
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: snapshot.data![index].id,
                            name: snapshot.data![index].name,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: snapshot.data![index],
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
