class ApiConstants {
  ApiConstants._();

  // static const String baseUrl = "http://127.0.0.1:8000/api";
  // static const String baseUrl = "http://localhost/veekas-api/public/api";
  static const String baseUrl = "https://veekas-ecommerce-api.onrender.com/api";

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
  static const String categories = "/categories";
  static const String deleteCategory = "/categories/delete";

  // Sub Category
  static const String subCategory = "/sub-categories";

  // Brand
  static const String brand = "/brands";

  // Product
  // static const String product = "/products";
  //
  // static const String deleteProduct =
  //     "/products/delete";
  //
  // static const String lowStockProducts =
  //     "/products/low-stock";
  static const String products = '$baseUrl/products';

  static String productById(int id) {
    return '$products/$id';
  }

  static String productLowStock(int limit) {
    return '$products/low-stock?limit=$limit';
  }

  static String productAddStock(int id) {
    return '$products/$id/add-stock';
  }
  static const String productVariants =
      '/product-variants';
  static String productRemoveStock(int id) {
    return '$products/$id/remove-stock';
  }
  static const String lowStockProducts =
      '$baseUrl/products/low-stock';
  static const String deleteProduct = '$baseUrl/products/delete';
  static const String subCategories =
      "$baseUrl/subcategories";

  static const String deleteSubCategory =
      "$baseUrl/subcategories/delete";

  static const String deleteBrand = "/brands/delete";

  // ============================================================
  // CART
  // ============================================================

  static const String cart = '/cart';

  static String cartByUser(int userId) {
    return '$cart/$userId';
  }

  static String updateCart(int cartId) {
    return '$cart/$cartId';
  }

  static String deleteCart(int cartId) {
    return '$cart/delete/$cartId';
  }

  static String restoreCart(int cartId) {
    return '$cart/restore/$cartId';
  }

  // ============================================================
// ADDRESS
// ============================================================

  static const String addresses = '/addresses';

  static String addressesByUser(int userId) {
    return '$addresses/$userId';
  }

  static String updateAddress(int id) {
    return '$addresses/$id';
  }

  static String deleteAddress(int id) {
    return '$addresses/delete/$id';
  }

  static String restoreAddress(int id) {
    return '$addresses/restore/$id';
  }

  static String defaultAddress(int id) {
    return '$addresses/default/$id';
  }

// ============================================================
// ORDER
// ============================================================

  static const String orders = '/orders';

  static String orderDetails(int id) {
    return '/orders/$id';
  }

  static String updateOrderStatus(int id) {
    return '/orders/status/$id';
  }
  static const String customerOrders = '/customer/orders';

}