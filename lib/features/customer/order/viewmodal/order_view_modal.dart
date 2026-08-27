import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../customer_order_model.dart';
import '../repository/order_repository.dart';


// ============================================================
// CUSTOMER ORDER REPOSITORY PROVIDER
// ============================================================

final customerOrderRepositoryProvider =
Provider<CustomerOrderRepository>((ref) {
  return CustomerOrderRepository();
});


// ============================================================
// PLACE ORDER PROVIDER
// ============================================================

final customerOrderViewModelProvider =
StateNotifierProvider<
    CustomerOrderViewModel,
    AsyncValue<CustomerPlaceOrderResponseModel?>>(
      (ref) {
    final repository =
    ref.watch(customerOrderRepositoryProvider);

    return CustomerOrderViewModel(repository);
  },
);


// ============================================================
// PLACE ORDER VIEW MODEL
// ============================================================

class CustomerOrderViewModel
    extends StateNotifier<
        AsyncValue<CustomerPlaceOrderResponseModel?>> {

  final CustomerOrderRepository _repository;

  CustomerOrderViewModel(
      this._repository,
      ) : super(
    AsyncData<CustomerPlaceOrderResponseModel?>(null),
  );


  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<CustomerPlaceOrderResponseModel> placeOrder({
    required int addressId,
    required String paymentMethod,
  }) async {

    state = const AsyncLoading();

    try {

      final result =
      await _repository.placeOrder(
        addressId: addressId,
        paymentMethod: paymentMethod,
      );

      state =
          AsyncData<CustomerPlaceOrderResponseModel?>(
            result,
          );

      return result;

    } catch (e, stackTrace) {

      state =
          AsyncError<CustomerPlaceOrderResponseModel?>(
            e,
            stackTrace,
          );

      rethrow;
    }
  }
}


// ============================================================
// CUSTOMER ORDER LIST PROVIDER
// ============================================================

final customerOrderListViewModelProvider =
StateNotifierProvider<
    CustomerOrderListViewModel,
    AsyncValue<List<CustomerOrderResponseModel>>>(
      (ref) {
    final repository =
    ref.watch(customerOrderRepositoryProvider);

    return CustomerOrderListViewModel(repository);
  },
);


// ============================================================
// CUSTOMER ORDER LIST VIEW MODEL
// ============================================================

class CustomerOrderListViewModel
    extends StateNotifier<
        AsyncValue<List<CustomerOrderResponseModel>>> {

  final CustomerOrderRepository _repository;

  CustomerOrderListViewModel(
      this._repository,
      ) : super(
    const AsyncLoading(),
  ) {
    getCustomerOrders();
  }


  // ============================================================
  // GET CUSTOMER ORDERS
  // ============================================================

  Future<void> getCustomerOrders() async {

    state = const AsyncLoading();

    try {

      final orders =
      await _repository.getCustomerOrders();

      state =
          AsyncData<List<CustomerOrderResponseModel>>(
            orders,
          );

    } catch (e, stackTrace) {

      state =
          AsyncError<List<CustomerOrderResponseModel>>(
            e,
            stackTrace,
          );
    }
  }
}