class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.success({
    required T data,
    String message = '',
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.failure(String message) {
    return ApiResponse(
      success: false,
      message: message,
      data: null,
    );
  }
}