import 'package:dio/dio.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/api_service.dart';
import '../../../core/storage/preference_service.dart';
import '../model/auth_response_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  // ===========================
  // Login
  // ===========================

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _apiService.post(
        ApiConstants.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await PreferenceService.saveToken(authResponse.token);

      return authResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Login Failed",
      );
    }
  }

  // ===========================
  // Register
  // ===========================

  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _apiService.post(
        ApiConstants.register,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "mobile": mobile,
          "email": email,
          "password": password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await PreferenceService.saveToken(authResponse.token);

      return authResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Registration Failed",
      );
    }
  }

  // ===========================
// Logout
// ===========================

  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Logout Failed",
      );
    }
  }

  // ===========================
  // Login Status
  // ===========================

  bool isLoggedIn() {
    return PreferenceService.isLoggedIn();
  }

  // ===========================
  // Token
  // ===========================

  String? getToken() {
    return PreferenceService.getToken();
  }


}