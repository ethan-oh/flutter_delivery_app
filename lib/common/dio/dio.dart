import 'package:delivery_flutter_app/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio dio;

  CustomInterceptor(this.storage, this.dio);
  // 요청 보내기 전
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

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
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  // 에러 발생 시
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
        '[ERR] ${err.response?.statusCode} [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) return handler.reject(err);

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path.contains('auth/token');

    if (isStatus401 && !isPathRefresh) {
      try {
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
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
  }
}
