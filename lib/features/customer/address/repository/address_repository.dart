import 'package:dio/dio.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/storage/preference_service.dart';
import '../modal/address_model.dart';

class AddressRepository {
  final ApiService _apiService;

  AddressRepository(this._apiService);

  // ============================================================
  // GET ADDRESSES
  // ============================================================

  Future<List<AddressModel>> getAddresses() async {
    try {
      final userId =
      PreferenceService.getUserId();

      if (userId == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final response =
      await _apiService.get(
        ApiConstants.addressesByUser(
          userId,
        ),
      );

      if (response.data['status'] == true) {
        final List<dynamic> data =
        response.data['data'] is List
            ? response.data['data']
            : [];

        return data
            .whereType<Map>()
            .map(
              (item) =>
              AddressModel.fromJson(
                Map<String, dynamic>.from(
                  item,
                ),
              ),
        )
            .toList();
      }

      throw Exception(
        response.data['message'] ??
            'Failed to get addresses',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to get addresses',
      );
    }
  }

  // ============================================================
  // ADD ADDRESS
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
    try {
      final userId =
      PreferenceService.getUserId();

      if (userId == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final response =
      await _apiService.post(
        ApiConstants.addresses,
        data: {
          'user_id': userId,

          'full_name': fullName,
          'mobile': mobile,
          'alternate_mobile':
          alternateMobile,

          'address_line_1':
          addressLine1,
          'address_line_2':
          addressLine2,
          'landmark': landmark,

          'city': city,
          'state': state,
          'country': country,
          'pincode': pincode,

          'address_type':
          addressType,

          'is_default': isDefault,
        },
      );

      if (response.data['status'] == true) {
        final address =
        AddressModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );

        // Save selected address locally.
        await PreferenceService
            .saveAddressId(
          address.id,
        );

        await PreferenceService
            .saveAddress(
          address.toJson(),
        );

        return address;
      }

      throw Exception(
        response.data['message'] ??
            'Failed to add address',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to add address',
      );
    }
  }

  // ============================================================
  // UPDATE ADDRESS
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
    try {
      final response =
      await _apiService.post(
        ApiConstants.updateAddress(id),
        data: {
          'full_name': fullName,
          'mobile': mobile,
          'alternate_mobile':
          alternateMobile,

          'address_line_1':
          addressLine1,
          'address_line_2':
          addressLine2,
          'landmark': landmark,

          'city': city,
          'state': state,
          'country': country,
          'pincode': pincode,

          'address_type':
          addressType,

          'is_default': isDefault,
        },
      );

      if (response.data['status'] == true) {
        final address =
        AddressModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );

        await PreferenceService
            .saveAddressId(
          address.id,
        );

        await PreferenceService
            .saveAddress(
          address.toJson(),
        );

        return address;
      }

      throw Exception(
        response.data['message'] ??
            'Failed to update address',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to update address',
      );
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteAddress(
      int id,
      ) async {
    try {
      final response =
      await _apiService.post(
        ApiConstants.deleteAddress(id),
      );

      if (response.data['status'] != true) {
        throw Exception(
          response.data['message'] ??
              'Failed to delete address',
        );
      }

      if (PreferenceService
          .getAddressId() ==
          id) {
        await PreferenceService
            .removeAddressId();

        await PreferenceService
            .removeAddress();
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to delete address',
      );
    }
  }

  // ============================================================
  // SET DEFAULT
  // ============================================================

  Future<AddressModel> setDefault(
      int id,
      ) async {
    try {
      final response =
      await _apiService.post(
        ApiConstants.defaultAddress(id),
      );

      if (response.data['status'] == true) {
        final address =
        AddressModel.fromJson(
          Map<String, dynamic>.from(
            response.data['data'],
          ),
        );

        await PreferenceService
            .saveAddressId(
          address.id,
        );

        await PreferenceService
            .saveAddress(
          address.toJson(),
        );

        return address;
      }

      throw Exception(
        response.data['message'] ??
            'Failed to set default address',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Failed to set default address',
      );
    }
  }
}