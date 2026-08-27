import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../payment_modal.dart';
import '../repository/payment_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final paymentRepositoryProvider = Provider<PaymentRepository>(
      (ref) {
    return PaymentRepository();
  },
);

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final paymentViewModelProvider = StateNotifierProvider<
    PaymentViewModel,
    AsyncValue<PaymentResponseModel?>>(
      (ref) {
    return PaymentViewModel(
      ref.read(paymentRepositoryProvider),
    );
  },
);

class PaymentViewModel
    extends StateNotifier<AsyncValue<PaymentResponseModel?>> {
  final PaymentRepository _repository;

  PaymentViewModel(
      this._repository,
      ) : super(
    const AsyncValue.data(null),
  );

// ============================================================
// CREATE PAYMENT
// ============================================================

  Future<PaymentResponseModel?> createPayment({
    required int orderId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await _repository.createPayment(
        orderId: orderId,
      );

      state = AsyncValue.data(response);

      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );

      rethrow;
    }
  }

// ============================================================
// PAYMENT SUCCESS
// ============================================================

  Future<PaymentResponseModel?> paymentSuccess({
    required int paymentId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await _repository.paymentSuccess(
        paymentId: paymentId,
      );

      state = AsyncValue.data(response);

      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );

      rethrow;
    }
  }

// ============================================================
// PAYMENT FAILED
// ============================================================

  Future<PaymentResponseModel?> paymentFailed({
    required int paymentId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await _repository.paymentFailed(
        paymentId: paymentId,
      );

      state = AsyncValue.data(response);

      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );

      rethrow;
    }
  }

// ============================================================
// RESET
// ============================================================

  void reset() {
    state = const AsyncValue.data(null);
  }
}
