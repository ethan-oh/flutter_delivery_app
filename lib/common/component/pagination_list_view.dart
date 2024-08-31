import 'package:delivery_flutter_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_flutter_app/common/model/model_with_id.dart';
import 'package:delivery_flutter_app/common/provider/pagination_provider.dart';
import 'package:delivery_flutter_app/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationItemBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  final PaginationItemBuilder<T> itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget? lastWidget;
  final String emptyText;

  const PaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
    this.separatorBuilder,
    this.lastWidget,
    this.emptyText = '데이터가 없습니다.',
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView<T>> {
  late final ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(listener);
  }

  listener() {
    PaginationUtils.paginate(
        controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // case 1: 첫 fetch 로딩
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // case 2: 에러 발생
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message),
          TextButton.icon(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      );
    }

    state as CursorPagination;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(widget.provider.notifier).paginate(forceRefetch: true);
      },
      child: state.data.isEmpty
          ? Center(
              child: Text(widget.emptyText),
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              itemCount: state.data.length + 1,
              separatorBuilder: widget.separatorBuilder ??
                  (context, index) => const Divider(
                        height: 33,
                        thickness: 0,
                      ),
              itemBuilder: (context, index) {
                if (index == state.data.length) {
                  return Center(
                    child: state is CursorPaginationFetchingMore
                        ? const CircularProgressIndicator()
                        : widget.lastWidget ?? const SizedBox.shrink(),
                  );
                }
                final model = state.data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: widget.itemBuilder(context, index, model),
                );
              },
            ),
    );
  }
}
