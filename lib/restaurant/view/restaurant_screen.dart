import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_flutter_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(scrollListener);
  }

  scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // case 1: 첫 fetch 로딩
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // case 2: 에러 발생
    if (data is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.message),
          TextButton.icon(
            onPressed: () {
              ref
                  .read(restaurantProvider.notifier)
                  .paginate(forceRefetch: true);
            },
            icon: Icon(Icons.refresh),
            label: Text('새로고침'),
          ),
        ],
      );
    }

    data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        child: Center(
          child: ListView.separated(
            controller: controller,
            itemCount: data.data.length + 1,
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
            itemBuilder: (context, index) {
              if (index == data.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: data is CursorPaginationFetchingMore
                        ? CircularProgressIndicator()
                        : Text(
                            '마지막 식당입니다',
                            style: TextStyle(),
                          ),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                        id: data.data[index].id,
                        name: data.data[index].name,
                      ),
                    ),
                  );
                },
                child: RestaurantCard.fromModel(
                  model: data.data[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
