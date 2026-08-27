import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../Repository/shipping_track_repository.dart';
import '../shipment_tracking_modal.dart';


// ============================================================
// REPOSITORY PROVIDER
// ============================================================

final shipmentTrackingRepositoryProvider =
Provider<ShipmentTrackingRepository>(
      (ref) {
    return ShipmentTrackingRepository();
  },
);

// ============================================================
// VIEW MODEL PROVIDER
// ============================================================

final shipmentTrackingViewModelProvider =
StateNotifierProvider<
    ShipmentTrackingViewModel,
    AsyncValue<ShipmentTrackingModel?>>(
      (ref) {
    return ShipmentTrackingViewModel(
      ref.read(
        shipmentTrackingRepositoryProvider,
      ),
    );
  },
);

// ============================================================
// VIEW MODEL
// ============================================================

class ShipmentTrackingViewModel
    extends StateNotifier<
        AsyncValue<ShipmentTrackingModel?>> {
  final ShipmentTrackingRepository _repository;

  ShipmentTrackingViewModel(
      this._repository,
      ) : super(
    const AsyncValue.data(null),
  );

  // ============================================================
  // TRACK SHIPMENT
  // ============================================================

  Future<void> trackShipment(
      String trackingNumber,
      ) async {
    final trimmedTrackingNumber =
    trackingNumber.trim();

    if (trimmedTrackingNumber.isEmpty) {
      state = AsyncValue.error(
        Exception(
          'Please enter a tracking number.',
        ),
        StackTrace.current,
      );

      return;
    }

    state = const AsyncValue.loading();

    try {
      final shipment =
      await _repository.trackShipment(
        trimmedTrackingNumber,
      );

      state = AsyncValue.data(shipment);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const AsyncValue.data(null);
  }
}