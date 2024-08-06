import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/provider/user_me_provider.dart';
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
  // GoRouter 리다이렉트 로직 (Auth)
  // Splash Screen
  String? redirectLogic(GoRouterState state) {
    ref.read(userMeProvider.notifier);
    if (true) {
      return '/login';
    }
    return null;
  }
}
