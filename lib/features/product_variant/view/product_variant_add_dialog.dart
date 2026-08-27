import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodal/product_view_modal.dart';

class AddProductVariantDialog
    extends ConsumerStatefulWidget {
  final int productId;

  const AddProductVariantDialog({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<AddProductVariantDialog>
  createState() =>
      _AddProductVariantDialogState();
}

class _AddProductVariantDialogState
    extends ConsumerState<
        AddProductVariantDialog> {

  final _formKey =
  GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final attribute1NameController =
  TextEditingController();

  final attribute1ValueController =
  TextEditingController();

  final attribute2NameController =
  TextEditingController();

  final attribute2ValueController =
  TextEditingController();

  final attribute3NameController =
  TextEditingController();

  final attribute3ValueController =
  TextEditingController();

  final actualPriceController =
  TextEditingController();

  final discountPriceController =
  TextEditingController();

  final stockController =
  TextEditingController();

  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    attribute1NameController.dispose();
    attribute1ValueController.dispose();

    attribute2NameController.dispose();
    attribute2ValueController.dispose();

    attribute3NameController.dispose();
    attribute3ValueController.dispose();

    actualPriceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();

    super.dispose();
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  Future<void> _addVariant() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(
        productVariantViewModelProvider
            .notifier,
      );
      //     .addProductVariant(
      //   productId:
      //   widget.productId,
      //
      //   attribute1Name:
      //   _nullableValue(
      //     attribute1NameController,
      //   ),
      //
      //   attribute1Value:
      //   _nullableValue(
      //     attribute1ValueController,
      //   ),
      //
      //   attribute2Name:
      //   _nullableValue(
      //     attribute2NameController,
      //   ),
      //
      //   attribute2Value:
      //   _nullableValue(
      //     attribute2ValueController,
      //   ),
      //
      //   attribute3Name:
      //   _nullableValue(
      //     attribute3NameController,
      //   ),
      //
      //   attribute3Value:
      //   _nullableValue(
      //     attribute3ValueController,
      //   ),
      //
      //   actualPrice:
      //   double.parse(
      //     actualPriceController
      //         .text
      //         .trim(),
      //   ),
      //
      //   discountPrice:
      //   double.parse(
      //     discountPriceController
      //         .text
      //         .trim(),
      //   ),
      //
      //   stock: int.parse(
      //     stockController
      //         .text
      //         .trim(),
      //   ),
      // );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Product variant added successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // NULLABLE VALUE
  // ============================================================

  String? _nullableValue(
      TextEditingController controller,
      ) {
    final value =
    controller.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return value;
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool requiredField = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: !isLoading,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border:
        const OutlineInputBorder(),
      ),
      validator: requiredField
          ? (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return '$label is required';
        }

        return null;
      }
          : null,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return AlertDialog(
      title: const Text(
        'Add Product Variant',
        style: TextStyle(
          fontWeight:
          FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 650,

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                // ==================================================
                // PRODUCT
                // ==================================================

                Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    14,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Colors
                        .grey
                        .shade100,
                    borderRadius:
                    BorderRadius
                        .circular(
                      8,
                    ),
                  ),
                  child: Row(
                    children: [

                      const Icon(
                        Icons
                            .inventory_2_outlined,
                        size: 20,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        'Product ID: ${widget.productId}',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // ATTRIBUTE 1
                // ==================================================

                const Text(
                  'Attribute 1',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute1NameController,
                        label:
                        'Attribute Name',
                        hint:
                        'Example: Color',
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute1ValueController,
                        label:
                        'Attribute Value',
                        hint:
                        'Example: Red',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // ATTRIBUTE 2
                // ==================================================

                const Text(
                  'Attribute 2',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute2NameController,
                        label:
                        'Attribute Name',
                        hint:
                        'Example: Size',
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute2ValueController,
                        label:
                        'Attribute Value',
                        hint:
                        'Example: XL',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // ==================================================
                // ATTRIBUTE 3
                // ==================================================

                const Text(
                  'Attribute 3',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute3NameController,
                        label:
                        'Attribute Name',
                        hint:
                        'Example: Material',
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        attribute3ValueController,
                        label:
                        'Attribute Value',
                        hint:
                        'Example: Cotton',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // PRICE
                // ==================================================

                Row(
                  children: [

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        actualPriceController,
                        label:
                        'Actual Price',
                        requiredField:
                        true,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        discountPriceController,
                        label:
                        'Discount Price',
                        requiredField:
                        true,
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                // ==================================================
                // STOCK
                // ==================================================

                _buildTextField(
                  controller:
                  stockController,
                  label: 'Stock',
                  requiredField: true,
                  keyboardType:
                  TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

      actions: [

        TextButton(
          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),

        ElevatedButton(
          onPressed:
          isLoading
              ? null
              : _addVariant,
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          )
              : const Text(
            'Add Variant',
          ),
        ),
      ],
    );
  }
}