import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../modal/shipment_modal.dart';
import '../repository/shipment_repository.dart';

// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final shipmentRepositoryProvider =
Provider<ShipmentRepository>(
      (ref) {
    return ShipmentRepository();
  },
);

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final shipmentViewModelProvider =
StateNotifierProvider<
    ShipmentViewModel,
    AsyncValue<List<ShipmentListModel>>>(
      (ref) {
    return ShipmentViewModel(
      ref.read(shipmentRepositoryProvider),
    );
  },
);

// ============================================================
// VIEW MODEL
// ============================================================

class ShipmentViewModel
    extends StateNotifier<
        AsyncValue<List<ShipmentListModel>>> {
  final ShipmentRepository _repository;

  ShipmentViewModel(
      this._repository,
      ) : super(
    const AsyncValue.loading(),
  );

  // ============================================================
  // GET SHIPMENTS
  // ============================================================

  Future<void> getShipments() async {
    state = const AsyncValue.loading();

    try {
      final shipments =
      await _repository.getShipments();

      state = AsyncValue.data(shipments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // CREATE SHIPMENT
  // ============================================================

  Future<void> createShipment({
    required int orderId,
    required String deliveryPartner,
  }) async {
    await _repository.createShipment(
      orderId: orderId,
      deliveryPartner: deliveryPartner,
    );

    await getShipments();
  }

  // ============================================================
  // GET SHIPMENT DETAILS
  // ============================================================

  Future<ShipmentDetailModel> getShipmentDetails(
      int shipmentId,
      ) async {
    return _repository.getShipmentDetails(
      shipmentId,
    );
  }

  // ============================================================
  // UPDATE SHIPPING STATUS
  // ============================================================

  Future<void> updateShippingStatus({
    required int shipmentId,
    required String shippingStatus,
  }) async {
    await _repository.updateShippingStatus(
      shipmentId: shipmentId,
      shippingStatus: shippingStatus,
    );

    await getShipments();
  }

  // ============================================================
  // CANCEL SHIPMENT
  // ============================================================

  Future<void> cancelShipment(
      int shipmentId,
      ) async {
    await _repository.cancelShipment(
      shipmentId,
    );

    await getShipments();
  }
}