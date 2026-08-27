import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._();

  static SharedPreferences? _preferences;

  // ============================================================
  // KEYS
  // ============================================================

  static const String tokenKey = 'token';
  static const String userIdKey = 'user_id';

  static const String addressIdKey = 'selected_address_id';
  static const String addressKey = 'selected_address';
  static const String roleKey = 'role';

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ============================================================
  // TOKEN
  // ============================================================

  static Future<bool> saveToken(String token) async {
    return await _preferences!.setString(
      tokenKey,
      token,
    );
  }

  static String? getToken() {
    return _preferences!.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    await _preferences!.remove(tokenKey);
  }

  // ============================================================
  // USER ID
  // ============================================================

  static Future<bool> saveUserId(int userId) async {
    return await _preferences!.setInt(
      userIdKey,
      userId,
    );
  }

  static int? getUserId() {
    return _preferences!.getInt(
      userIdKey,
    );
  }

  static Future<void> removeUserId() async {
    await _preferences!.remove(userIdKey);
  }

  // ======================================================================
  // USER ROLE
  // ============================================================
// USER ROLE
// ============================================================

  static Future<bool> saveUserRole(String role) async {
    return await _preferences!.setString(
      roleKey,
      role,
    );
  }

  static String? getUserRole() {
    return _preferences!.getString(
      roleKey,
    );
  }

  static Future<void> removeUserRole() async {
    await _preferences!.remove(
      roleKey,
    );
  }
  // ======================================================================

  // ============================================================
  // SELECTED ADDRESS ID
  // ============================================================

  static Future<bool> saveAddressId(
      int addressId,
      ) async {
    return await _preferences!.setInt(
      addressIdKey,
      addressId,
    );
  }

  static int? getAddressId() {
    return _preferences!.getInt(
      addressIdKey,
    );
  }

  static Future<void> removeAddressId() async {
    await _preferences!.remove(
      addressIdKey,
    );
  }

  // ============================================================
  // SELECTED ADDRESS
  // ============================================================

  static Future<bool> saveAddress(
      Map<String, dynamic> address,
      ) async {
    return await _preferences!.setString(
      addressKey,
      jsonEncode(address),
    );
  }

  static Map<String, dynamic>? getAddress() {
    final value = _preferences!.getString(
      addressKey,
    );

    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(
        jsonDecode(value),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> removeAddress() async {
    await _preferences!.remove(
      addressKey,
    );
  }

  // ============================================================
  // LOGIN STATUS
  // ============================================================

  static bool isLoggedIn() {
    final token = getToken();

    return token != null &&
        token.isNotEmpty;
  }

  // ============================================================
  // CLEAR
  // ============================================================

  static Future<bool> clear() async {
    return await _preferences!.clear();
  }
}