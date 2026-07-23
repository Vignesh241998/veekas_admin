import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiService {
  ApiService();

  static final _dio = DioClient.instance;

  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return await _dio.get(
      url,
      queryParameters: queryParameters,
    );
  }

  Future<Response> post(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    return await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put(
      String url, {
        dynamic data,
      }) async {
    return await _dio.put(
      url,
      data: data,
    );
  }

  Future<Response> delete(
      String url, {
        dynamic data,
      }) async {
    return await _dio.delete(
      url,
      data: data,
    );
  }
}