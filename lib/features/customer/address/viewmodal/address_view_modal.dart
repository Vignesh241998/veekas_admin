import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../shared/providers/app_providers.dart';
import '../modal/address_model.dart';
import '../repository/address_repository.dart';

final addressRepositoryProvider =
Provider<AddressRepository>((ref) {
  return AddressRepository(
    ref.read(apiServiceProvider),
  );
});

final addressViewModelProvider =
StateNotifierProvider<
    AddressViewModel,
    AsyncValue<List<AddressModel>>>(
      (ref) {
    return AddressViewModel(
      ref.read(addressRepositoryProvider),
    );
  },
);

class AddressViewModel
    extends StateNotifier<
        AsyncValue<List<AddressModel>>> {
  final AddressRepository _repository;

  AddressViewModel(this._repository)
      : super(
    const AsyncValue.data([]),
  );

  // ============================================================
  // GET
  // ============================================================

  Future<void> getAddresses() async {
    state = const AsyncValue.loading();

    try {
      final result =
      await _repository.getAddresses();

      state = AsyncValue.data(
        result,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e,
        stackTrace,
      );
    }
  }

  // ============================================================
  // ADD
  // ============================================================

  Future<AddressModel> addAddress({
    required String fullName,
    required String mobile,
    String? alternateMobile,
    required String addressLine1,
    String? addressLine2,
    String? landmark,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String addressType,
    required bool isDefault,
  }) async {
    final result =
    await _repository.addAddress(
      fullName: fullName,
      mobile: mobile,
      alternateMobile: alternateMobile,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      landmark: landmark,
      city: city,
      state: state,
      country: country,
      pincode: pincode,
      addressType: addressType,
      isDefault: isDefault,
    );

    await getAddresses();

    return result;
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<AddressModel> updateAddress({
    required int id,
    required String fullName,
    required String mobile,
    String? alternateMobile,
    required String addressLine1,
    String? addressLine2,
    String? landmark,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String addressType,
    required bool isDefault,
  }) async {
    final result =
    await _repository.updateAddress(
      id: id,
      fullName: fullName,
      mobile: mobile,
      alternateMobile: alternateMobile,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      landmark: landmark,
      city: city,
      state: state,
      country: country,
      pincode: pincode,
      addressType: addressType,
      isDefault: isDefault,
    );

    await getAddresses();

    return result;
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteAddress(
      int id,
      ) async {
    await _repository.deleteAddress(
      id,
    );

    await getAddresses();
  }

  // ============================================================
  // DEFAULT
  // ============================================================

  Future<void> setDefault(
      int id,
      ) async {
    await _repository.setDefault(
      id,
    );

    await getAddresses();
  }
}