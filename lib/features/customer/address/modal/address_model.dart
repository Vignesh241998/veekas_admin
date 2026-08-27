class AddressModel {
  final int id;
  final int userId;

  final String fullName;
  final String mobile;
  final String alternateMobile;

  final String addressLine1;
  final String addressLine2;
  final String landmark;

  final String city;
  final String state;
  final String country;
  final String pincode;

  final String addressType;

  final bool isDefault;

  final String status;

  final String createdAt;
  final String updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.mobile,
    required this.alternateMobile,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.addressType,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AddressModel(
      id: int.tryParse(
        json['id'].toString(),
      ) ??
          0,

      userId: int.tryParse(
        json['user_id'].toString(),
      ) ??
          0,

      fullName:
      json['full_name']?.toString() ?? '',

      mobile:
      json['mobile']?.toString() ?? '',

      alternateMobile:
      json['alternate_mobile']?.toString() ?? '',

      addressLine1:
      json['address_line_1']?.toString() ?? '',

      addressLine2:
      json['address_line_2']?.toString() ?? '',

      landmark:
      json['landmark']?.toString() ?? '',

      city:
      json['city']?.toString() ?? '',

      state:
      json['state']?.toString() ?? '',

      country:
      json['country']?.toString() ?? 'India',

      pincode:
      json['pincode']?.toString() ?? '',

      addressType:
      json['address_type']?.toString() ?? 'HOME',

      isDefault:
      json['is_default'] == true ||
          json['is_default'] == 1 ||
          json['is_default'] == '1',

      status:
      json['status']?.toString() ?? 'ACTIVE',

      createdAt:
      json['created_at']?.toString() ?? '',

      updatedAt:
      json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,

      'full_name': fullName,
      'mobile': mobile,
      'alternate_mobile': alternateMobile,

      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'landmark': landmark,

      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,

      'address_type': addressType,

      'is_default': isDefault,

      'status': status,

      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}