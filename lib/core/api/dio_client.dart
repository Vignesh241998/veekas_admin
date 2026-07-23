import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'dio_interceptor.dart';

class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
    ),
  )..interceptors.add(AppInterceptor());
}