import 'package:delivery_flutter_app/common/view/root_tab.dart';
import 'package:delivery_flutter_app/common/view/splash_screen.dart';
import 'package:delivery_flutter_app/order/view/order_done_screen.dart';
import 'package:delivery_flutter_app/restaurant/view/basket_screen.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
import 'package:delivery_flutter_app/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) {
    return AuthProvider(ref: ref);
  },
);

// gorouter의 refreshListenable 사용을 위해 userMeProvider를 관찰하는 ChangeNotifier가 필요
class AuthProvider extends ChangeNotifier {
  // final AuthRepository repository;
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) : super() {
    ref.listen<UserModelBase?>(
      userMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  // route 등록
  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              name: RestaurantDetailScreen.routeName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, state) => const BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (_, state) => const OrderDoneScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
      ];

  // GoRouter 리다이렉트 로직 (Auth)
  // Splash Screen
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final bool isLoginScreen = state.location == '/login';
    final bool isSplashScreen = state.location == '/splash';
    final UserModelBase? user = ref.read(userMeProvider);

    // user가 null이고 현재 로그인 화면이면
    // 그대로 두고 아니면 로그인 페이지로 이동
    if (user == null) {
      return isLoginScreen ? null : '/login';
    }

    // user가 null이 아님

    // 1) user is UserModel (실제 데이터 존재)
    // 현재 스플래시 화면(데이터가 있다면 앱이 이미 로그인 되어있는 상태)이거나
    // 로그인 화면(로그인 버튼 클릭하여 데이터가 생성)이면
    // home 화면으로 보내라
    if (user is UserModel) {
      return (isSplashScreen || isLoginScreen) ? '/' : null;
    }

    // Error 상황
    if (user is UserModelError) {
      return isLoginScreen ? null : '/login';
    }

    return null;
  }

  logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
