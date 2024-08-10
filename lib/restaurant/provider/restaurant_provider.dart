import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_flutter_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantProvider, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantProvider(repository: repository);
    return notifier;
  },
);

class RestaurantProvider
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantProvider({required super.repository});

  getDetail({required String id}) async {
    // 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터 요청 시도
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때는 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // 레스토랑 리스트(state)에서 입력받은 id와 일치하는 레스토랑을 찾아서
    // 해당 데이터를 기존에서 최신으로 변경한다.
    // 즉 이미 detail 요청한 restaurant의 detail 정보가 캐싱된다.
    if (pState.data
        .where(
          (element) => element.id == id,
        )
        .isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList(),
      );
    }
  }
}
