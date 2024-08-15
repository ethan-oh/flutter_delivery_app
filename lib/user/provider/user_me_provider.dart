import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/common/storage/secure_storage.dart';
import 'package:delivery_flutter_app/user/model/user_model.dart';
import 'package:delivery_flutter_app/user/repository/auth_repository.dart';
import 'package:delivery_flutter_app/user/repository/user_me_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeProvider, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final repository = ref.watch(userMeRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);
    return UserMeProvider(
        authRepository: authRepository,
        repository: repository,
        storage: storage);
  },
);

class UserMeProvider extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;
  UserMeProvider({
    required this.storage,
    required this.repository,
    required this.authRepository,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    try {
      final resp = await repository.getMe();
      state = resp;
    } catch (e) {
      state = UserModelError(message: e.toString());
    }
  }

  Future<UserModelBase> login(
      {required String username, required String password}) async {
    state = UserModelLoading();

    try {
      final resp =
          await authRepository.login(username: username, password: password);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getMe();
      // watch로 관찰할 수 있게 상태 저장
      state = userResp;
      return userResp;
    } on DioException catch (_) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
    // 로그인 후 바로 사용하려면 반환한 값을 사용
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
