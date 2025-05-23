import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/common/dio/dio.dart';
import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/model/pagination_params.dart';
import 'package:delivery_flutter_app/common/repository/base_pagination_repository.dart';
import 'package:delivery_flutter_app/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>(
  (ref, rid) {
    final dio = ref.watch(dioProvider);
    final repository = RestaurantRatingRepository(dio,
        baseUrl: 'http://$ip/restaurant/$rid/rating');

    return repository;
  },
);

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @override
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? params = const PaginationParams(),
  });
}
