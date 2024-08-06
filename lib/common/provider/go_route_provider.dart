import 'package:delivery_flutter_app/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    // watch가 아니고 read인 이유 :
    // authProvider가 변경될 때마다 (UserModel이 변경될 때)
    // GoRouter를 리빌드할 필요가 없기 때문. (watch는 view 관련 부분에서만)
    final provider = ref.read(authProvider);
    return GoRouter(
      routes: provider.routes,
      initialLocation: '/splash',
      refreshListenable: provider,
      redirect: provider.redirectLogic,
    );
  },
);
