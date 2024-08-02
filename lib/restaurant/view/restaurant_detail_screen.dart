import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/rating/component/rating_card.dart';
import 'package:delivery_flutter_app/rating/model/rating_model.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String name;
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          _buildTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) _buildLoading(),
          if (state is RestaurantDetailModel) _buildLabel(text: '메뉴'),
          if (state is RestaurantDetailModel)
            _buildProducts(
              products: state.products,
            ),
          if (state is RestaurantDetailModel)
            _buildLabel(text: '리뷰 ${state.ratingsCount}개'),
          if (ratingsState is CursorPagination<RatingModel>)
            _buildRatings(ratings: ratingsState.data),
        ],
      ),
    );
  }

  SliverPadding _buildRatings({required List<RatingModel> ratings}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return RatingCard.fromModel(model: ratings[index]);
          },
          childCount: ratings.length,
        ),
      ),
    );
  }

  SliverPadding _buildLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Skeletonizer.zone(child: Bone.text(words: 4)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skeletonizer.zone(child: Bone.text(words: 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skeletonizer.zone(child: Bone.text(words: 3)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skeletonizer.zone(child: Bone.text(words: 5)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Skeletonizer.zone(child: Bone.text(words: 1)),
            ),
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Skeletonizer.zone(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Bone.square(
                        size: 56,
                      ),
                      title: Bone.text(
                        words: 1,
                      ),
                      subtitle: Bone.text(
                        words: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildLabel({required String text}) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16, bottom: 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          text,
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
              padding: const EdgeInsets.only(bottom: 16),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        isDetail: true,
        model: model,
      ),
    );
  }
}
