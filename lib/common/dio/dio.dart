import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:delivery_flutter_app/common/storage/secure_storage.dart';
import 'package:delivery_flutter_app/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider(
  (ref) {
    final dio = Dio();
    final storage = ref.watch(secureStorageProvider);
    dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));
    return dio;
  },
);

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });
  // 요청 보내기 전
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('[요청] [${options.method}] ${options.uri}');

    // header에 {'accessToken' : true}가 있다면
    // 즉, 토큰이 필요한 요청이라면
    if (options.headers['accessToken'] == 'true') {
      // 헤더의 임시 값을 삭제
      options.headers.remove('accessToken');
      // 토큰을 읽은 후
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      // header에 토큰을 추가
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더의 임시 값을 삭제
      options.headers.remove('refreshToken');
      // 토큰을 읽은 후
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      // header에 토큰을 추가
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    super.onRequest(options, handler);
  }

  // 응답 시
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '[응답] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  // 에러 발생 시
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        '[에러] ${err.response?.statusCode} [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) return handler.reject(err);

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path.contains('auth/token');

    if (isStatus401 && !isPathRefresh) {
      try {
        final dio = Dio()..interceptors;
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // 토큰 변경
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        // storage에 저장
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        // 기존 요청 재전송
        final response = await dio.fetch(options);
        // 해결 되었음을 알려줌
        debugPrint('토큰 갱신 및 재요청 성공');
        return handler.resolve(response);
      } on DioException catch (e) {
        // userMeProvider와 dioProvider가 서로 참조하는
        // CircularDependency Error 를 막기 위해
        // userMeProvider의 logout을 실행하는 것이 아니라
        // dio를 참조하지 않는 authProvider에서
        // userMeProvider의 logout을 호출하는 함수를 만들어 실행한다.
        debugPrint('리프레시 만료');
        ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }
  }
}
