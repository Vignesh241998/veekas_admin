class VariantAttributeModel {
  final int? id;
  final int variantId;
  final String attributeName;
  final String attributeValue;

  VariantAttributeModel({
    this.id,
    required this.variantId,
    required this.attributeName,
    required this.attributeValue,
  });

  factory VariantAttributeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return VariantAttributeModel(
      id: json['id'],

      variantId:
      int.tryParse(
        json['variant_id'].toString(),
      ) ??
          0,

      attributeName:
      json['attribute_name']?.toString() ?? '',

      attributeValue:
      json['attribute_value']?.toString() ?? '',
    );
  }
}