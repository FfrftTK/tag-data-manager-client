import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

Interceptor _appInterceptor() =>
    InterceptorsWrapper(onRequest: (RequestOptions options) async {
//      options.headers.putIfAbsent(key, () => null)
      return options;
    }, onResponse: (Response response) async {
      return response; // continue
    }, onError: (DioError e) async {
      return e;
    });

class AppDioClient with DioMixin implements Dio {
  factory AppDioClient(
    String baseUrl,
  ) {
    if (_instance == null) {
      final dio = AppDioClient._()
        ..httpClientAdapter = DefaultHttpClientAdapter()
        ..options = BaseOptions(
          baseUrl: baseUrl,
        );

      dio.interceptors.add(LogInterceptor(responseBody: true));
      dio.interceptors.add(_appInterceptor());

      _instance = dio;
    }
    return _instance;
  }

  AppDioClient._();

  static AppDioClient _instance;
}
