import 'package:flutter/material.dart';

class VariantAttributeField {
  final TextEditingController nameController;
  final TextEditingController valueController;

  VariantAttributeField({
    String name = '',
    String value = '',
  })  : nameController =
  TextEditingController(
    text: name,
  ),
        valueController =
        TextEditingController(
          text: value,
        );

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}