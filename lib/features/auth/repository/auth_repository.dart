import 'package:dio/dio.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/api_service.dart';
import '../../../core/storage/preference_service.dart';
import '../model/auth_response_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  // ============================================================
  // LOGIN
  // ============================================================

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

      // ============================================================
      // PARSE API RESPONSE
      // ============================================================

      final authResponse =
      AuthResponseModel.fromJson(
        response.data,
      );

      // ============================================================
      // SAVE TOKEN
      // ============================================================

      await PreferenceService.saveToken(
        authResponse.token,
      );

      // ============================================================
      // SAVE USER ID
      // ============================================================

      await PreferenceService.saveUserId(
        authResponse.user.id,
      );

      // ============================================================
      // SAVE USER ROLE
      // ============================================================

      await PreferenceService.saveUserRole(
        authResponse.user.role,
      );

      // ============================================================
      // RETURN RESPONSE
      // ============================================================

      return authResponse;

    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Login Failed",
      );
    } catch (e) {
      throw Exception(
        "Login response parsing failed: $e",
      );
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      final Response response =
      await _apiService.post(
        ApiConstants.register,
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "mobile": mobile,
          "email": email,
          "password": password,
        },
      );

      final authResponse =
      AuthResponseModel.fromJson(
        response.data,
      );

      // ============================================================
      // SAVE TOKEN
      // ============================================================

      await PreferenceService.saveToken(
        authResponse.token,
      );

      // ============================================================
      // SAVE USER ID
      // ============================================================

      await PreferenceService.saveUserId(
        authResponse.user.id,
      );

      // ============================================================
      // SAVE USER ROLE
      // ============================================================

      await PreferenceService.saveUserRole(
        authResponse.user.role,
      );

      return authResponse;

    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Registration Failed",
      );
    } catch (e) {
      throw Exception(
        "Registration response parsing failed: $e",
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _apiService.post(
        ApiConstants.logout,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Logout Failed",
      );
    }
  }

  // ============================================================
  // LOGIN STATUS
  // ============================================================

  bool isLoggedIn() {
    return PreferenceService.isLoggedIn();
  }

  // ============================================================
  // TOKEN
  // ============================================================

  String? getToken() {
    return PreferenceService.getToken();
  }
}