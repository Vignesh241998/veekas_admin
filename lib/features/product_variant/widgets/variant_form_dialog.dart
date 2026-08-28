import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/modal/product_modal.dart';
import '../../product/repository/product_repository.dart';

import '../modal/product_variant_modal.dart';
import '../viewmodal/product_view_modal.dart';

class VariantFormDialog extends ConsumerStatefulWidget {
  final int? productId;
  final ProductVariantModel? variant;

  const VariantFormDialog({
    super.key,
    this.productId,
    this.variant,
  });

  @override
  ConsumerState<VariantFormDialog> createState() =>
      _VariantFormDialogState();
}

class _VariantFormDialogState
    extends ConsumerState<VariantFormDialog> {
  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // ============================================================
  // PRODUCT
  // ============================================================

  final ProductRepository _productRepository =
  ProductRepository();

  List<ProductModel> products = [];

  int? selectedProductId;

  bool isProductsLoading = true;

  String? productError;

  // ============================================================
  // ATTRIBUTES
  // ============================================================

  final List<_AttributeRow> attributeRows = [];

  // ============================================================
  // PRICE
  // ============================================================

  final TextEditingController actualPriceController =
  TextEditingController();

  final TextEditingController discountPriceController =
  TextEditingController();

  final TextEditingController stockController =
  TextEditingController();

  // ============================================================
  // LOADING
  // ============================================================

  bool isLoading = false;

  // ============================================================
  // EDIT MODE
  // ============================================================

  bool get isEditMode =>
      widget.variant != null;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    selectedProductId =
        widget.productId ??
            widget.variant?.productId;

    _loadProducts();

    _loadExistingVariant();
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> _loadProducts() async {
    try {
      setState(() {
        isProductsLoading = true;
        productError = null;
      });

      final result =
      await _productRepository.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        isProductsLoading = false;
      });

      // If a product was already supplied,
      // make sure it exists in dropdown.
      if (selectedProductId != null) {
        final exists = result.any(
              (product) =>
          product.id == selectedProductId,
        );

        if (!exists && !isEditMode) {
          setState(() {
            selectedProductId = null;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isProductsLoading = false;
        productError = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // ============================================================
  // LOAD EXISTING VARIANT
  // ============================================================

  void _loadExistingVariant() {
    final variant = widget.variant;

    if (variant == null) {
      // Add mode:
      // Start with one empty attribute.
      attributeRows.add(
        _AttributeRow(),
      );

      return;
    }

    // ==========================================================
    // PRICE
    // ==========================================================

    actualPriceController.text =
        variant.actualPrice
            .toString();

    discountPriceController.text =
        variant.discountPrice
            .toString();

    stockController.text =
        variant.stock.toString();

    // ==========================================================
    // ATTRIBUTES
    // ==========================================================

    for (final attribute
    in variant.attributes) {
      attributeRows.add(
        _AttributeRow(
          name: attribute.attributeName,
          value: attribute.attributeValue,
        ),
      );
    }

    // If no attributes exist,
    // still show one row.
    if (attributeRows.isEmpty) {
      attributeRows.add(
        _AttributeRow(),
      );
    }
  }

  // ============================================================
  // ADD ATTRIBUTE
  // ============================================================

  void _addAttribute() {
    setState(() {
      attributeRows.add(
        _AttributeRow(),
      );
    });
  }

  // ============================================================
  // REMOVE ATTRIBUTE
  // ============================================================

  void _removeAttribute(int index) {
    setState(() {
      attributeRows[index].dispose();
      attributeRows.removeAt(index);
    });
  }

  // ============================================================
  // GET ATTRIBUTES
  // ============================================================

  List<Map<String, String>> _getAttributes() {
    final List<Map<String, String>>
    attributes = [];

    for (final row in attributeRows) {
      final name =
      row.nameController.text.trim();

      final value =
      row.valueController.text.trim();

      if (name.isEmpty &&
          value.isEmpty) {
        continue;
      }

      attributes.add({
        'name': name,
        'value': value,
      });
    }

    return attributes;
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveVariant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedProductId == null) {
      _showError(
        'Please select a product.',
      );
      return;
    }

    final attributes =
    _getAttributes();

    // Validate attribute rows.
    for (final attribute in attributes) {
      if (attribute['name']!
          .trim()
          .isEmpty ||
          attribute['value']!
              .trim()
              .isEmpty) {
        _showError(
          'Please enter both attribute name and value.',
        );
        return;
      }
    }

    if (attributes.isEmpty) {
      _showError(
        'Please add at least one attribute.',
      );
      return;
    }

    final actualPrice =
    double.tryParse(
      actualPriceController.text.trim(),
    );

    final discountPrice =
    double.tryParse(
      discountPriceController.text.trim(),
    );

    final stock =
    int.tryParse(
      stockController.text.trim(),
    );

    if (actualPrice == null) {
      _showError(
        'Please enter a valid actual price.',
      );
      return;
    }

    if (discountPrice == null) {
      _showError(
        'Please enter a valid discount price.',
      );
      return;
    }

    if (stock == null) {
      _showError(
        'Please enter a valid stock.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // EDIT
      // ========================================================

      if (isEditMode) {
        final variantId =
            widget.variant!.id;

        if (variantId == null) {
          throw Exception(
            'Variant ID not found.',
          );
        }

        await ref
            .read(
          productVariantViewModelProvider
              .notifier,
        )
            .updateVariant(
          variantId: variantId,
          attributes: attributes,
          actualPrice: actualPrice,
          discountPrice: discountPrice,
          stock: stock,
        );
      }

      // ========================================================
      // ADD
      // ========================================================

      else {
        await ref
            .read(
          productVariantViewModelProvider
              .notifier,
        )
            .addVariant(
          productId:
          selectedProductId!,
          attributes: attributes,
          actualPrice: actualPrice,
          discountPrice: discountPrice,
          stock: stock,
        );
      }

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Variant updated successfully'
                : 'Variant added successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showError(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    for (final row in attributeRows) {
      row.dispose();
    }

    actualPriceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditMode
            ? 'Edit Product Variant'
            : 'Add Product Variant',

        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 700,

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // ==================================================
                // PRODUCT
                // ==================================================

                _buildProductDropdown(),

                const SizedBox(
                  height: 22,
                ),

                // ==================================================
                // ATTRIBUTES TITLE
                // ==================================================

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Attributes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed:
                      isLoading
                          ? null
                          : _addAttribute,

                      icon: const Icon(
                        Icons.add,
                        size: 18,
                      ),

                      label: const Text(
                        'Add Attribute',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                // ==================================================
                // ATTRIBUTE ROWS
                // ==================================================

                ...List.generate(
                  attributeRows.length,
                      (index) {
                    return _buildAttributeRow(
                      index,
                    );
                  },
                ),

                const SizedBox(
                  height: 22,
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
                        hint:
                        '1999',
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                        requiredField:
                        true,
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child:
                      _buildTextField(
                        controller:
                        discountPriceController,
                        label:
                        'Discount Price',
                        hint:
                        '1499',
                        keyboardType:
                        const TextInputType
                            .numberWithOptions(
                          decimal: true,
                        ),
                        requiredField:
                        true,
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
                  hint: '10',
                  keyboardType:
                  TextInputType.number,
                  requiredField: true,
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
          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF965DC2),
            foregroundColor:
            Colors.white,
          ),

          onPressed:
          isLoading
              ? null
              : _saveVariant,

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
              : Text(
            isEditMode
                ? 'Update Variant'
                : 'Add Variant',
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT DROPDOWN
  // ============================================================

  Widget _buildProductDropdown() {
    if (isProductsLoading) {
      return Container(
        height: 58,

        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        decoration: BoxDecoration(
          color:
          const Color(0xFFF7F7F8),

          borderRadius:
          BorderRadius.circular(
            8,
          ),
        ),

        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),

            SizedBox(
              width: 12,
            ),

            Text(
              'Loading products...',
            ),
          ],
        ),
      );
    }

    if (productError != null) {
      return Container(
        padding:
        const EdgeInsets.all(
          12,
        ),

        decoration: BoxDecoration(
          color:
          const Color(0xFFFFF5F5),

          borderRadius:
          BorderRadius.circular(
            8,
          ),

          border: Border.all(
            color: Colors.red.shade200,
          ),
        ),

        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),

            const SizedBox(
              width: 8,
            ),

            Expanded(
              child: Text(
                productError!,
                style:
                const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            TextButton(
              onPressed:
              _loadProducts,
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Container(
        padding:
        const EdgeInsets.all(
          14,
        ),

        decoration: BoxDecoration(
          color:
          const Color(0xFFFFF7ED),

          borderRadius:
          BorderRadius.circular(
            8,
          ),
        ),

        child: const Row(
          children: [
            Icon(
              Icons.info_outline,
              color:
              Colors.orange,
            ),

            SizedBox(
              width: 8,
            ),

            Text(
              'No products available.',
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: selectedProductId,

      isExpanded: true,

      decoration:
      InputDecoration(
        labelText: 'Product',
        hintText:
        'Select Product',

        prefixIcon:
        const Icon(
          Icons
              .inventory_2_outlined,
        ),

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),

          borderSide:
          const BorderSide(
            color:
            Color(0xFFDCDCE1),
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),

          borderSide:
          const BorderSide(
            color:
            Color(0xFF965DC2),
            width: 2,
          ),
        ),
      ),

      items: products.map(
            (product) {
          return DropdownMenuItem<int>(
            value: product.id,

            child: Text(
              product.productName,

              overflow:
              TextOverflow.ellipsis,

              style:
              const TextStyle(
                fontSize: 14,
              ),
            ),
          );
        },
      ).toList(),

      onChanged:
      isLoading
          ? null
          : (value) {
        setState(() {
          selectedProductId =
              value;
        });
      },

      validator: (value) {
        if (value == null) {
          return 'Please select a product';
        }

        return null;
      },
    );
  }

  // ============================================================
  // ATTRIBUTE ROW
  // ============================================================

  Widget _buildAttributeRow(
      int index) {
    final row =
    attributeRows[index];

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
      const EdgeInsets.all(
        12,
      ),

      decoration: BoxDecoration(
        color:
        const Color(0xFFF8F7FA),

        borderRadius:
        BorderRadius.circular(
          10,
        ),

        border: Border.all(
          color:
          const Color(0xFFE5E1E8),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Expanded(
            child:
            _buildAttributeField(
              controller:
              row.nameController,
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
            _buildAttributeField(
              controller:
              row.valueController,
              label:
              'Attribute Value',
              hint:
              'Example: Red',
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Padding(
            padding:
            const EdgeInsets.only(
              top: 8,
            ),

            child: IconButton(
              tooltip:
              'Remove Attribute',

              onPressed:
              isLoading
                  ? null
                  : () {
                _removeAttribute(
                  index,
                );
              },

              icon:
              const Icon(
                Icons
                    .delete_outline,
                color:
                Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ATTRIBUTE FIELD
  // ============================================================

  Widget _buildAttributeField({
    required TextEditingController
    controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,

      enabled: !isLoading,

      decoration:
      InputDecoration(
        labelText: label,
        hintText: hint,

        border:
        const OutlineInputBorder(),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController
    controller,
    required String label,
    String? hint,
    bool requiredField = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,

      enabled: !isLoading,

      keyboardType:
      keyboardType,

      decoration:
      InputDecoration(
        labelText: label,
        hintText: hint,

        border:
        const OutlineInputBorder(),
      ),

      validator:
      requiredField
          ? (value) {
        if (value == null ||
            value
                .trim()
                .isEmpty) {
          return '$label is required';
        }

        return null;
      }
          : null,
    );
  }
}

// ============================================================
// ATTRIBUTE ROW MODEL
// ============================================================

class _AttributeRow {
  final TextEditingController
  nameController;

  final TextEditingController
  valueController;

  _AttributeRow({
    String? name,
    String? value,
  })  : nameController =
  TextEditingController(
    text: name ?? '',
  ),
        valueController =
        TextEditingController(
          text: value ?? '',
        );

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}