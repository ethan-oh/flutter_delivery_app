import 'package:delivery_flutter_app/common/component/basket_icon_button.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/utils/pagination_utils.dart';
import 'package:delivery_flutter_app/product/component/product_card.dart';
import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:delivery_flutter_app/rating/component/rating_card.dart';
import 'package:delivery_flutter_app/rating/model/rating_model.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_rating_provider.dart';
import 'package:delivery_flutter_app/user/model/basket_item_model.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

final class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'detail';
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));

    // product탭에서 restaurantProvider에 존재하지 않는 값의 detail을 요청했을 때
    // state.data에 매칭되는 id가 없으므로 state = null을 반환한다.
    // 따라서 restaurantProvider에 존재하는 경우는 로딩 중에 skeleton 등을 그리지만
    // 이 경우에는 CircularProgressIndicator를 그린다.
    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: Material(
        borderRadius: BorderRadius.circular(300),
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.primary,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(300),
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(5, 8, 11, 8),
            child: BasketIconButton(
              isFloatingActionButton: true,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          Consumer(
            builder: (context, ref, child) => _buildSliverAppbar(
              state,
              ref.watch(basketProvider),
            ),
          ),
          _buildTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) _buildLoading(),
          if (state is RestaurantDetailModel) _buildLabel(text: '메뉴'),
          if (state is RestaurantDetailModel) _buildProducts(restaurant: state),
          if (state is RestaurantDetailModel)
            _buildLabel(text: '리뷰 ${state.ratingsCount}개'),
          if (ratingsState is CursorPagination<RatingModel>)
            _buildRatings(ratingsState: ratingsState),
        ],
      ),
    );
  }

////////////////////

  SliverAppBar _buildSliverAppbar(
      RestaurantModel state, List<BasketItemModel> basket) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      floating: false,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
      elevation: 0,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          state.name,
          style: TextStyle(
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 30,
                color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
              ),
            ],
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white, // 텍스트 색상
          ),
        ),
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: ObjectKey(state.id),
              child: Image.network(
                state.thumbUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              height: 160,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildRatings({required CursorPaginationBase ratingsState}) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == ratingsState.data.length) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: ratingsState is CursorPaginationFetchingMore
                      ? const CircularProgressIndicator()
                      : const Text('마지막 댓글입니다'),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RatingCard.fromModel(
                model: ratingsState.data[index],
              ),
            );
          },
          childCount: (ratingsState as CursorPagination).data.length + 1,
        ),
      ),
    );
  }

  SliverPadding _buildLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Skeletonizer.zone(
                  child: Bone.multiText(
                lines: 4,
              )),
            ),
            ...List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Skeletonizer.zone(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Bone.square(
                        size: 56,
                      ),
                      title: Bone.multiText(
                        lines: 3,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Bone.button(
                            width: 50,
                            height: 20,
                          ),
                        ],
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
      padding: const EdgeInsets.only(top: 30, left: 16, bottom: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding _buildProducts({required RestaurantDetailModel restaurant}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = restaurant.products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                        product: ProductModel(
                      id: model.id,
                      name: model.name,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      price: model.price,
                      restaurant: restaurant,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProductCard.fromModel(
                  model: model,
                ),
              ),
            );
          },
          childCount: restaurant.products.length,
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
