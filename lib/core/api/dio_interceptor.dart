import 'package:dio/dio.dart';

import '../storage/preference_service.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    final token = PreferenceService.getToken();

    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    print("REQUEST : ${options.method}");
    print("URL : ${options.uri}");
    print("HEADERS : ${options.headers}");
    print("BODY : ${options.data}");

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    print("RESPONSE : ${response.statusCode}");
    print(response.data);

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    print("ERROR : ${err.response?.statusCode}");
    print(err.response?.data);

    handler.next(err);
  }
}