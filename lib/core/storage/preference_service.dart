import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._();

  static SharedPreferences? _preferences;

  static const String tokenKey = 'token';

  /// Initialize in main()
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // =========================
  // Token
  // =========================

  static Future<bool> saveToken(String token) async {
    return await _preferences!.setString(tokenKey, token);
  }

  static String? getToken() {
    return _preferences!.getString(tokenKey);
  }

  // static Future<bool> removeToken() async {
  //   return await _preferences!.remove(tokenKey);
  // }

  static Future<bool> clear() async {
    return await _preferences!.clear();
  }

  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}