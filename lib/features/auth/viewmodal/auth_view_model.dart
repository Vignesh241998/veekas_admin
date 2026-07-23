import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/storage/preference_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../model/auth_response_model.dart';
import '../repository/auth_repository.dart';

/// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(apiServiceProvider),
  );
});

/// ViewModel Provider
final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AsyncValue<AuthResponseModel?>>(
      (ref) {
    return AuthViewModel(
      ref.read(authRepositoryProvider),
    );
  },
);

class AuthViewModel extends StateNotifier<AsyncValue<AuthResponseModel?>> {
  final AuthRepository _repository;

  AuthViewModel(this._repository)
      : super(const AsyncValue.data(null));

  // ==========================
  // Login
  // ==========================

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.login(
        email: email,
        password: password,
      );

      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // ==========================
  // Register
  // ==========================

  Future<void> register({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        email: email,
        password: password,
      );

      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  // ==========================
  // Logout
  // ==========================

  // Future<void> logout() async {
  //   await _repository.logout();
  //
  //   state = const AsyncData(null);
  // }

  // ==========================
  // Login Status
  // ==========================

  bool isLoggedIn() {
    return _repository.isLoggedIn();
  }

  String? getToken() {
    return _repository.getToken();
  }

  Future<void> logout() async {
    await _repository.logout();
    await PreferenceService.removeToken();
  }
}