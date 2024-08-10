import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:delivery_flutter_app/rating/model/rating_model.dart';
import 'package:delivery_flutter_app/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingProvider, CursorPaginationBase, String>((ref, rid) {
  final repository = ref.watch(restaurantRatingRepositoryProvider(rid));
  return RestaurantRatingProvider(repository: repository);
});

class RestaurantRatingProvider
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingProvider({required super.repository});
}
