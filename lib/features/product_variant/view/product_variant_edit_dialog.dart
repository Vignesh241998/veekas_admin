import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_variant_modal.dart';
import '../viewmodal/product_view_modal.dart';

class EditProductVariantDialog
    extends ConsumerStatefulWidget {
  final ProductVariantModel variant;

  const EditProductVariantDialog({
    super.key,
    required this.variant,
  });

  @override
  ConsumerState<EditProductVariantDialog> createState() =>
      _EditProductVariantDialogState();
}

class _EditProductVariantDialogState
    extends ConsumerState<EditProductVariantDialog> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController attribute1NameController;
  late final TextEditingController attribute1ValueController;

  late final TextEditingController attribute2NameController;
  late final TextEditingController attribute2ValueController;

  late final TextEditingController attribute3NameController;
  late final TextEditingController attribute3ValueController;

  late final TextEditingController actualPriceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController stockController;

  bool isLoading = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // attribute1NameController =
    //     TextEditingController(
    //       text: widget.variant.attribute1Name ?? '',
    //     );
    //
    // attribute1ValueController =
    //     TextEditingController(
    //       text: widget.variant.attribute1Value ?? '',
    //     );
    //
    // attribute2NameController =
    //     TextEditingController(
    //       text: widget.variant.attribute2Name ?? '',
    //     );
    //
    // attribute2ValueController =
    //     TextEditingController(
    //       text: widget.variant.attribute2Value ?? '',
    //     );
    //
    // attribute3NameController =
    //     TextEditingController(
    //       text: widget.variant.attribute3Name ?? '',
    //     );
    //
    // attribute3ValueController =
    //     TextEditingController(
    //       text: widget.variant.attribute3Value ?? '',
    //     );

    actualPriceController =
        TextEditingController(
          text: widget.variant.actualPrice.toString(),
        );

    discountPriceController =
        TextEditingController(
          text: widget.variant.discountPrice.toString(),
        );

    stockController =
        TextEditingController(
          text: widget.variant.stock.toString(),
        );
  }

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
  // UPDATE VARIANT
  // ============================================================

  Future<void> _updateVariant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(
        productVariantViewModelProvider.notifier,
      );
      //     .updateProductVariant(
      //   id: widget.variant.id,
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
      //   actualPrice: double.parse(
      //     actualPriceController.text.trim(),
      //   ),
      //
      //   discountPrice: double.parse(
      //     discountPriceController.text.trim(),
      //   ),
      //
      //   stock: int.parse(
      //     stockController.text.trim(),
      //   ),
      // );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product variant updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
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
    final value = controller.text.trim();

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
      enabled: !isLoading,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Product Variant',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 650,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                // ==================================================
                // PRODUCT
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Product ID: ${widget.variant.productId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // ATTRIBUTE 1
                // ==================================================

                const Text(
                  'Attribute 1',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute1NameController,
                        label: 'Attribute Name',
                        hint: 'Example: Color',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute1ValueController,
                        label: 'Attribute Value',
                        hint: 'Example: Red',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==================================================
                // ATTRIBUTE 2
                // ==================================================

                const Text(
                  'Attribute 2',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute2NameController,
                        label: 'Attribute Name',
                        hint: 'Example: Size',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute2ValueController,
                        label: 'Attribute Value',
                        hint: 'Example: XL',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==================================================
                // ATTRIBUTE 3
                // ==================================================

                const Text(
                  'Attribute 3',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute3NameController,
                        label: 'Attribute Name',
                        hint: 'Example: Material',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller:
                        attribute3ValueController,
                        label: 'Attribute Value',
                        hint: 'Example: Cotton',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // PRICE
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller:
                        actualPriceController,
                        label: 'Actual Price',
                        requiredField: true,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller:
                        discountPriceController,
                        label: 'Discount Price',
                        requiredField: true,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ==================================================
                // STOCK
                // ==================================================

                _buildTextField(
                  controller: stockController,
                  label: 'Stock',
                  requiredField: true,
                  keyboardType: TextInputType.number,
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
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed:
          isLoading ? null : _updateVariant,
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          )
              : const Text(
            'Update Variant',
          ),
        ),
      ],
    );
  }
}