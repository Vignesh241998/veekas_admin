import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../modal/order_modal.dart';
import '../repository/order_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final orderRepositoryProvider =
Provider<OrderRepository>(
      (ref) {
    return OrderRepository();
  },
);

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final orderViewModelProvider =
StateNotifierProvider<
    OrderViewModel,
    AsyncValue<List<OrderListModel>>>(
      (ref) {
    return OrderViewModel(
      ref.read(orderRepositoryProvider),
    );
  },
);

// ============================================================
// VIEW MODEL
// ============================================================

class OrderViewModel
    extends StateNotifier<
        AsyncValue<List<OrderListModel>>> {
  final OrderRepository _repository;

  OrderViewModel(
      this._repository,
      ) : super(
    const AsyncValue.loading(),
  );

// ============================================================
// GET ORDERS
// ============================================================

  Future<void> getOrders() async {
    state = const AsyncValue.loading();

    try {
      final orders =
      await _repository.getOrders();

      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );
    }
  }

// ============================================================
// GET ORDER DETAILS
// ============================================================

  Future<OrderDetailModel> getOrderDetails(
      int orderId,
      ) async {
    return _repository.getOrderDetails(
      orderId,
    );
  }

// ============================================================
// UPDATE ORDER STATUS
// ============================================================

  Future<void> updateOrderStatus({
    required int orderId,
    required String orderStatus,
  }) async {
    await _repository.updateOrderStatus(
      orderId: orderId,
      orderStatus: orderStatus,
    );

    await getOrders();
  }
}

