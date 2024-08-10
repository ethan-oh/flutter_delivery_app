import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/model/model_with_id.dart';
import 'package:delivery_flutter_app/common/model/pagination_params.dart';
import 'package:delivery_flutter_app/common/repository/base_pagination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 데이터 추가 요청
    bool fetchMore = false,
    // 강제로 로딩할지 (true: CursorPaginationLoading())
    bool forceRefetch = false,
  }) async {
    final isLoading = state is CursorPaginationLoading;
    final isRefetcing = state is CursorPaginationRefetching;
    final isFetcingMore = state is CursorPaginationFetchingMore;
    try {
      // 1) 요청이 필요 없는 경우
      // 1-1) 더이상 가져올 데이터가 없는 경우
      if (state is CursorPagination && !forceRefetch) {
        // CursorPagination 타입인 경우는 데이터가 있는 경우이기 때문에 캐스팅 가능
        final pState = state as CursorPagination;
        // hasMore = false 즉, 더이상 가져올 데이터가 없을 때
        // if (!pState.meta.hasMore && pState.data.length >= fetchCount) {
        if (!pState.meta.hasMore) {
          return;
        }
      }
      // 1-2) 이미 요청중인 상황이라 중복 요청을 막아야 하는 경우
      if (fetchMore && (isLoading || isRefetcing || isFetcingMore)) {
        return;
      }

      // 2) 요청이 필요한 경우
      // params 객체 생성
      PaginationParams params = PaginationParams(count: fetchCount);
      // 2-1) 데이터 추가 요청 받았을 때 처리 (fetchMore = true)
      if (fetchMore) {
        // fetchMore는 추가 요청할 때만 true로 넣을게 확실하니까 캐스팅 가능
        final pState = state as CursorPagination<T>;
        // 상태를 CursorPaginationFetchingMore(첫 요청 이후의 CursorPagination)
        // 로 변경 및 기존 data 넘겨줌.
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        // 첫 요청 이후부터는
        // last id(Cursor)를 params에 저장함으로써
        // 다음 요청 시 커서 정보를 알려줄 수 있음
        params = params.copyWith(after: pState.data.last.id);
      }
      // 2-2) 데이터를 처음부터 가져오는 상황 (첫 요청 or forceRefetch)
      else {
        // 데이터가 있는 경우라면
        // 기존 데이터를 보존한 채로 요청 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황(데이터를 유지할 필요가 없는 상황)
        else {
          state = CursorPaginationLoading();
        }
      }
      // 데이터 요청(fetchMore 전처리 완료)
      final resp = await repository.paginate(params: params);

      // 요청이 끝났는데 기존 데이터가 있는 경우
      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        // 기존 data에 새로운 데이터 추가
        // (CursorPaginationFetchingMore => CursorPagination)
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      }
      // 로딩중이거나 reFetching 상태일 때
      else {
        // 통째로 넣어줌
        state = resp;
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      state = CursorPaginationError(message: '데이터를 불러오는 데 실패했습니다.');
      return;
    }
  }
}
