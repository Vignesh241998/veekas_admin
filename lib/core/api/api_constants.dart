class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "http://127.0.0.1:8000/api";

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String profile = "/profile";

  // Dashboard
  static const String dashboard = "/dashboard";

  // Category
  static const String category = "/categories";

  // Sub Category
  static const String subCategory = "/sub-categories";

  // Brand
  static const String brand = "/brands";

  // Product
  static const String product = "/products";

}